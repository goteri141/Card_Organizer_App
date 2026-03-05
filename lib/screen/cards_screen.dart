import 'package:flutter/material.dart';
import '../models/folder.dart';
import '../models/card.dart';
import '../repositories/card_repository.dart';

class CardsScreen extends StatefulWidget {
  final Folder folder;

  const CardsScreen({super.key, required this.folder});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  final CardRepository _cardRepository = CardRepository();
  List<PlayingCard> _cards = [];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final cards =
        await _cardRepository.getCardsByFolderId(widget.folder.id!);

    setState(() {
      _cards = cards;
    });
  }

  Future<void> _deleteCard(PlayingCard card) async {
    await _cardRepository.deleteCard(card.id!);
    _loadCards();
  }


  String _buildImagePath(PlayingCard card) {
    String name = card.cardName.toLowerCase();
    String suit = card.suit.toLowerCase();
    return 'assets/cards/${name}_$suit.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folder.folderName),
      ),

      
      body: ListView.builder(
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final card = _cards[index];

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: Image.asset(
                _buildImagePath(card),
                width: 50,
                height: 50,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported),
              ),

              title: Text(card.cardName),
              subtitle: Text(card.suit),

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteCard(card),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}