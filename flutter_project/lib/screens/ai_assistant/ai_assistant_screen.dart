import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/app_state_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/voice_service.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final VoiceService _voiceService = VoiceService();
  final ImagePicker _picker = ImagePicker();
  bool _isListening = false;
  String? _selectedImageBase64;

  @override
  void initState() {
    super.initState();
    _voiceService.initVoice();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(source: source, imageQuality: 70);
      if (file != null) {
        final bytes = await file.readAsBytes();
        setState(() {
          _selectedImageBase64 = base64Encode(bytes);
        });
      }
    } catch (_) {}
  }

  Future<void> _handleSend() async {
    final text = _textController.text.trim();
    if (text.isEmpty && _selectedImageBase64 == null) return;

    final state = context.read<AppStateProvider>();
    final img = _selectedImageBase64;
    _textController.clear();
    setState(() => _selectedImageBase64 = null);

    _scrollToBottom();
    await state.sendChatMessage(
      text.isEmpty ? 'कृपया इस फसल की पत्ती/रोग की जांच करें और उपचार बताएं।' : text,
      base64Image: img,
    );
    _scrollToBottom();
  }

  void _toggleMic() async {
    if (_isListening) {
      await _voiceService.stopListening();
      setState(() => _isListening = false);
    } else {
      setState(() => _isListening = true);
      await _voiceService.startListening(
        onResult: (text) {
          setState(() {
            _textController.text = text;
          });
        },
        onListeningComplete: () {
          setState(() => _isListening = false);
          _handleSend();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppStateProvider>();
    final isHindi = state.currentLanguage == 'hi';

    final samplePrompts = isHindi
        ? [
            'गेहूँ में पीला रतुआ (Yellow Rust) के लक्षण व उपचार?',
            'सोयाबीन में इल्ली नियंत्रण के लिए सर्वोत्तम दवा?',
            'सरसों की फसल में प्रथम सिंचाई कब करनी चाहिए?',
            'धान में ब्लास्ट रोग की पहचान कैसे करें?',
          ]
        : [
            'Yellow rust treatment in wheat?',
            'Best pesticide for caterpillar in soybean?',
            'When to give first irrigation in mustard?',
            'Identification of blast disease in paddy?',
          ];

    return Scaffold(
      body: Column(
        children: [
          // Crop Disease Camera Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: AppColors.accentLight,
            child: Row(
              children: [
                const Icon(Icons.camera_alt, color: AppColors.accent, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isHindi ? 'फसल रोग पहचान: पौधे की फोटो खींचकर भेजें' : 'Crop Disease Diagnosis: Upload a leaf photo',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.brown),
                  ),
                ),
                TextButton(
                  onPressed: () => _pickImage(ImageSource.camera),
                  child: Text(isHindi ? 'कैमरा' : 'Camera', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // Chat Messages
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: state.chatMessages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final msg = state.chatMessages[index];
                final isUser = msg['role'] == 'user';

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isUser ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(16).copyWith(
                        bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(16),
                        bottomLeft: !isUser ? const Radius.circular(0) : const Radius.circular(16),
                      ),
                      border: Border.all(color: isUser ? AppColors.primaryDark : AppColors.border),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 1))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (msg['image'] != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                base64Decode(msg['image']),
                                height: 160,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        Text(
                          msg['text'] ?? '',
                          style: TextStyle(
                            color: isUser ? Colors.white : AppColors.textPrimary,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        if (!isUser) ...[
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.volume_up, size: 18, color: AppColors.primary),
                                onPressed: () {
                                  _voiceService.speak(msg['text'] ?? '', language: state.currentLanguage);
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ]
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Loading indicator
          if (state.isAiResponding)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isHindi ? 'एआई मित्र उत्तर तैयार कर रहा है...' : 'AI Mitra is typing advice...',
                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),

          // Sample questions scroll
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: samplePrompts.map((p) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ActionChip(
                    label: Text(p, style: const TextStyle(fontSize: 11)),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: AppColors.border),
                    onPressed: () {
                      _textController.text = p;
                      _handleSend();
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Image preview tag
          if (_selectedImageBase64 != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              color: AppColors.surfaceVariant,
              child: Row(
                children: [
                  const Icon(Icons.image, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(isHindi ? 'फोटो संलग्न की गई' : 'Photo attached', style: const TextStyle(fontSize: 12)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    onPressed: () => setState(() => _selectedImageBase64 = null),
                  ),
                ],
              ),
            ),

          // Bottom Input Bar
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add_photo_alternate, color: AppColors.primary),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
                IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none, color: _isListening ? Colors.red : AppColors.primary),
                  onPressed: _toggleMic,
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: _isListening
                          ? (isHindi ? 'सुन रहे हैं...' : 'Listening...')
                          : (isHindi ? 'सवाल लिखें या बोलें...' : 'Type or speak question...'),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    onSubmitted: (_) => _handleSend(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
                    onPressed: _handleSend,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
