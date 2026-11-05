import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/palette.dart';
import '../providers/palette_provider.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  static const Color primaryColor = Color(0xFF8065F6);
  static const Color backgroundColor = Color(0xFFF8F7FC);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<PaletteProvider>().fetchPalettes();
    });
  }

  Color parseColor(String hex) {
    try {
      final value = hex.replaceAll('#', '').trim();
      return Color(int.parse('FF$value', radix: 16));
    } catch (_) {
      return Colors.grey;
    }
  }

  Future<void> showPaletteDialog({Palette? palette}) async {
    final nameController = TextEditingController(text: palette?.name ?? '');

    final colorsController = TextEditingController(
      text: palette?.colors.join(', ') ?? '',
    );

    String type = palette?.colorType ?? 'Custom';

    final formKey = GlobalKey<FormState>();

    try {
      await showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: Text(
                  palette == null ? 'Create Palette' : 'Edit Palette',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                content: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: SizedBox(
                      width: 400,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Palette Name',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.palette_outlined),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Nama palet wajib diisi';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          TextFormField(
                            controller: colorsController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'HEX Colors',
                              hintText: '#FFB5C2, #B8C0FF',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.color_lens_outlined),
                            ),
                            validator: (value) {
                              final colors = (value ?? '')
                                  .split(',')
                                  .map((e) => e.trim())
                                  .toList();

                              if (colors.isEmpty ||
                                  colors.any(
                                    (color) =>
                                        !RegExp(r'^#?([0-9a-fA-F]{6})$')
                                            .hasMatch(color),
                                  )) {
                                return 'Masukkan HEX 6 digit, pisahkan koma';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          DropdownButtonFormField<String>(
                            initialValue: type,
                            decoration: const InputDecoration(
                              labelText: 'Palette Type',
                              border: OutlineInputBorder(),
                            ),
                            items:
                                const [
                                  'Custom',
                                  'Analogous',
                                  'Complementary',
                                  'Triadic',
                                  'Monochromatic',
                                ].map((item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setDialogState(() {
                                  type = value;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }

                      final colors = colorsController.text.split(',').map((e) {
                        final value = e.trim().toUpperCase();

                        return value.startsWith('#') ? value : '#$value';
                      }).toList();

                      final data = Palette(
                        id: palette?.id,
                        name: nameController.text.trim(),
                        colors: colors,
                        colorType: type,
                      );

                      try {
                        final provider = dialogContext.read<PaletteProvider>();

                        if (palette == null) {
                          await provider.addPalette(data);
                        } else {
                          await provider.editPalette(data);
                        }

                        if (!dialogContext.mounted) return;

                        Navigator.pop(dialogContext);

                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              palette == null
                                  ? 'Palette berhasil disimpan'
                                  : 'Palette berhasil diperbarui',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      } catch (e) {
                        if (!dialogContext.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Gagal menyimpan: $e'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    child: const Text('Save Palette'),
                  ),
                ],
              );
            },
          );
        },
      );
    } finally {
      nameController.dispose();
      colorsController.dispose();
    }
  }

  Future<void> confirmDelete(Palette palette) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Palette?'),
          content: Text('Apakah kamu yakin ingin menghapus "${palette.name}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true || palette.id == null) {
      return;
    }

    try {
      await context.read<PaletteProvider>().removePalette(palette.id!);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Palette berhasil dihapus'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget buildPaletteCard(Palette palette) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Row(
                children: palette.colors.map((hex) {
                  return Expanded(
                    child: Tooltip(
                      message: hex,
                      child: Container(color: parseColor(hex)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            palette.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 5),

          Text(
            palette.colorType,
            style: const TextStyle(
              fontSize: 12,
              color: primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            palette.colors.join('  '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 9, color: Colors.black54),
          ),

          const SizedBox(height: 5),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                tooltip: 'Edit Palette',
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  showPaletteDialog(palette: palette);
                },
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 19,
                  color: primaryColor,
                ),
              ),
              IconButton(
                tooltip: 'Delete Palette',
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  confirmDelete(palette);
                },
                icon: const Icon(
                  Icons.delete_outline,
                  size: 19,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.collections_rounded,
              size: 75,
              color: primaryColor,
            ),
            const SizedBox(height: 18),
            const Text(
              'Your Collection is Empty',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create your first palette and save it here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => showPaletteDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Create Palette'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        title: const Text(
          'My Collection',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: backgroundColor,
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () {
              context.read<PaletteProvider>().fetchPalettes();
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showPaletteDialog(),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('New Palette'),
      ),

      body: Consumer<PaletteProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          if (provider.errorMessage != null && provider.palettes.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_off_rounded,
                      size: 55,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Unable to load palettes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: provider.fetchPalettes,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (provider.palettes.isEmpty) {
            return buildEmptyState();
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1200
                  ? 4
                  : constraints.maxWidth >= 800
                  ? 3
                  : constraints.maxWidth >= 500
                  ? 2
                  : 1;

              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 100),
                itemCount: provider.palettes.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: constraints.maxWidth < 500 ? 1.15 : 0.95,
                ),
                itemBuilder: (context, index) {
                  return buildPaletteCard(provider.palettes[index]);
                },
              );
            },
          );
        },
      ),
    );
  }
}
