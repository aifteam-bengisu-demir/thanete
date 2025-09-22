import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thanette/src/providers/notes_provider.dart';
import 'package:thanette/src/screens/note_detail_screen.dart';
import 'package:thanette/src/widgets/thanette_logo.dart';

class NotesListScreen extends StatefulWidget {
  static const route = '/notes';
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(() {
      setState(() {}); // Rebuild to show/hide clear button
    });
  }

  void _onScroll() {
    final provider = context.read<NotesProvider>();
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        provider.hasMore &&
        !provider.isLoading) {
      provider.loadNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notes = context.watch<NotesProvider>().items;
    final provider = context.watch<NotesProvider>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8F9FA), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header section
              Container(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                child: Column(
                  children: [
                    // Logo and title row
                    Row(
                      children: [
                        const ThanetteLogo(size: 40),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Notların',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              Text(
                                'Tüm düşüncelerine tek yerden ulaş',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Stats container
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFEC60FF), Color(0xFFFF4D79)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${notes.length} not',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Search bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          context.read<NotesProvider>().searchNotes(value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Notlarında ara...',
                          prefixIcon: const Icon(
                            Icons.search_outlined,
                            color: Color(0xFF6B7280),
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Color(0xFF6B7280),
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    context.read<NotesProvider>().clearSearch();
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Notes grid
              Expanded(
                child: notes.isEmpty
                    ? _buildEmptyState()
                    : _buildNotesGrid(notes, provider),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFEC60FF), Color(0xFFFF4D79)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFEC60FF).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            final id = context.read<NotesProvider>().createNote();
            Navigator.of(context).pushNamed(
              NoteDetailScreen.route,
              arguments: NoteDetailArgs(id: id),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final provider = context.watch<NotesProvider>();
    final isSearching = provider.searchQuery.isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFEC60FF).withOpacity(0.1),
                    const Color(0xFFFF4D79).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                isSearching
                    ? Icons.search_off_outlined
                    : Icons.note_add_outlined,
                size: 60,
                color: const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isSearching ? 'Arama sonucu bulunamadı' : 'Henüz not yok',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isSearching
                  ? '"${provider.searchQuery}" için sonuç bulunamadı.\nFarklı kelimeler deneyin.'
                  : 'İlk notunu oluşturmak için\naşağıdaki butona dokun',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesGrid(List notes, provider) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: notes.length + (provider.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= notes.length) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFEC60FF),
                strokeWidth: 2,
              ),
            ),
          );
        }

        final note = notes[index];
        // Define a set of beautiful gradient colors for variety
        final gradients = [
          [const Color(0xFFEC60FF), const Color(0xFFFF4D79)], // Pink-Red
          [const Color(0xFF667EEA), const Color(0xFF764BA2)], // Purple-Blue
          [const Color(0xFF6EE7B7), const Color(0xFF3B82F6)], // Green-Blue
          [const Color(0xFFFBBF24), const Color(0xFFF59E0B)], // Yellow-Orange
          [const Color(0xFF8B5CF6), const Color(0xFFEC4899)], // Purple-Pink
          [const Color(0xFF10B981), const Color(0xFF059669)], // Green
        ];

        final gradientIndex = index % gradients.length;
        final cardGradient = gradients[gradientIndex];

        return GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            NoteDetailScreen.route,
            arguments: NoteDetailArgs(id: note.id),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  cardGradient[0].withOpacity(0.1),
                  cardGradient[1].withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: cardGradient[0].withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: cardGradient[0].withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Color indicator at top - now with matching gradient
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: cardGradient),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),

                const SizedBox(height: 16),

                // Note title - centered and larger
                Text(
                  note.title.isEmpty ? 'Başlıksız not' : note.title,
                  style: const TextStyle(
                    color: Color(0xFF1F2937),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                const Spacer(),

                // Small edit indicator - now with gradient colors
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        cardGradient[0].withOpacity(0.1),
                        cardGradient[1].withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: cardGradient[0].withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 14,
                        color: cardGradient[0],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Düzenle',
                        style: TextStyle(
                          color: cardGradient[0],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
