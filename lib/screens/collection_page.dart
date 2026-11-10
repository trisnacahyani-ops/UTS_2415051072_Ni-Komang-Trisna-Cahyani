import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/palette.dart';
import '../providers/palette_provider.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  static const Color primaryColor = Color(0xFF8065F6);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PaletteProvider>().fetchPalettes();
      }
    });
  }

  Color parseColor(String hex) {
    final value = hex.replaceAll('#', '').trim();
    return Color(int.parse('FF$value', radix: 16));
  }

  String normalizeHex(String hex) {
    final value = hex.replaceAll('#', '').trim().toUpperCase();
    return '#$value';
  }

  Future<void> copyPalette(Palette palette) async {
    final text = palette.colors.map(normalizeHex).join(', ');

    await Clipboard.setData(ClipboardData(text: text));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('HEX palette berhasil disalin!')),
    );
  }

  Future<void> exportPalette(Palette palette) async {
    final content =
        '''
${palette.name}
Palette Type: ${palette.colorType}

${palette.colors.map(normalizeHex).join('\n')}
''';

    await SharePlus.instance.share(
      ShareParams(title: 'ColorMate - ${palette.name}', text: content),
    );
  }

  Future<void> showPaletteDialog({Palette? palette}) async {
    final isEditing = palette != null;

    final nameController = TextEditingController(text: palette?.name ?? '');

    final colorsController = TextEditingController(
      text: palette?.colors.map(normalizeHex).join(', ') ?? '',
    );

    final types = [
      'Custom',
      'Analogous',
      'Complementary',
      'Triadic',
      'Monochromatic',
    ];

    String selectedType = palette?.colorType ?? 'Custom';

    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEditing ? 'Edit Palette' : 'Create Palette'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Palette Name',
                          prefixIcon: Icon(Icons.palette_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama palette wajib diisi';
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
                          hintText: '#8065F6, #FF8BA7, #FFC857',
                          helperText: 'Pisahkan setiap warna dengan koma',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Warna palette wajib diisi';
                          }

                          final colors = value.split(',');

                          for (final color in colors) {
                            final hex = color.trim().replaceAll('#', '');

                            if (!RegExp(r'^[0-9A-Fa-f]{6}$').hasMatch(hex)) {
                              return 'Format HEX harus 6 digit';
                            }
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: selectedType,
                        decoration: const InputDecoration(
                          labelText: 'Palette Type',
                          border: OutlineInputBorder(),
                        ),
                        items: types.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() {
                              selectedType = value;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: primaryColor),
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;

                    final colors = colorsController.text
                        .split(',')
                        .map((color) => normalizeHex(color.trim()))
                        .toList();

                    final newPalette = Palette(
                      id: palette?.id,
                      name: nameController.text.trim(),
                      colors: colors,
                      colorType: selectedType,
                    );

                    final provider = context.read<PaletteProvider>();

                    try {
                      if (isEditing) {
                        await provider.editPalette(newPalette);
                      } else {
                        await provider.addPalette(newPalette);
                      }

                      if (!dialogContext.mounted) return;
                      Navigator.pop(dialogContext);

                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isEditing
                                ? 'Palette berhasil diperbarui'
                                : 'Palette berhasil dibuat',
                          ),
                        ),
                      );
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal menyimpan palette: $e')),
                      );
                    }
                  },
                  child: Text(isEditing ? 'Update' : 'Save'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    colorsController.dispose();
  }

  Future<void> confirmDelete(Palette palette) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Palette?'),
          content: Text('Apakah kamu yakin ingin menghapus "${palette.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    try {
      await context.read<PaletteProvider>().removePalette(palette.id!);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Palette berhasil dihapus')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal menghapus palette: $e')));
    }
  }

  Widget buildPaletteCard(Palette palette) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    palette.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      showPaletteDialog(palette: palette);
                    } else if (value == 'delete') {
                      confirmDelete(palette);
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit_outlined),
                        title: Text('Edit'),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete_outline, color: Colors.red),
                        title: Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              palette.colorType,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Row(
                children: palette.colors.map((hex) {
                  return Expanded(
                    child: Container(height: 75, color: parseColor(hex)),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: palette.colors.map((hex) {
                return Text(
                  normalizeHex(hex),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => copyPalette(palette),
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text('Copy HEX'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    onPressed: () => exportPalette(palette),
                    icon: const Icon(Icons.ios_share, size: 16),
                    label: const Text('Export'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Collection',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () {
              context.read<PaletteProvider>().fetchPalettes();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showPaletteDialog(),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Create Palette'),
      ),
      body: Consumer<PaletteProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(provider.errorMessage!, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => provider.fetchPalettes(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (provider.palettes.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.palette_outlined,
                      size: 72,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Your collection is empty',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Save your favorite color palettes here.',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      onPressed: () => showPaletteDialog(),
                      icon: const Icon(Icons.add),
                      label: const Text('Create Palette'),
                    ),
                  ],
                ),
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              final columns = width >= 1200
                  ? 4
                  : width >= 850
                  ? 3
                  : width >= 550
                  ? 2
                  : 1;

              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                itemCount: provider.palettes.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 270,
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
