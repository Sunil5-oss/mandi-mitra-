import React, { useState, useEffect, useRef } from 'react';
import {
  Sprout,
  TrendingUp,
  CloudSun,
  Bot,
  FlaskConical,
  Calculator,
  Calendar,
  DollarSign,
  Landmark,
  Tractor,
  Store,
  Users,
  BookOpen,
  User,
  Mic,
  MicOff,
  Volume2,
  Camera,
  Download,
  Code2,
  Smartphone,
  Monitor,
  Search,
  CheckCircle2,
  AlertCircle,
  ExternalLink,
  Plus,
  RefreshCw,
  Send,
  ArrowUpRight,
  ArrowDownRight,
  Share2,
  Folder,
  FileCode,
  Check,
  ChevronRight,
  Sparkles,
  Phone,
  MapPin,
} from 'lucide-react';

// --- TYPES ---
interface MandiRecord {
  id: string;
  state: string;
  district: string;
  market: string;
  commodity: string;
  variety: string;
  minPrice: number;
  maxPrice: number;
  modalPrice: number;
  arrivalDate: string;
  trend: 'up' | 'down' | 'stable';
}

interface WeatherData {
  locationName: string;
  temperature: number;
  apparentTemperature: number;
  relativeHumidity: number;
  precipitationProbability: number;
  windSpeed: number;
  conditionText: string;
  agroAdvisory: string;
  dailyForecasts: Array<{
    dayName: string;
    date: string;
    maxTemp: number;
    minTemp: number;
    rainChance: number;
    condition: string;
  }>;
}

interface ChatMessage {
  id: string;
  role: 'user' | 'assistant';
  text: string;
  image?: string;
  timestamp: string;
}

interface CalendarEvent {
  id: string;
  cropName: string;
  activityType: string;
  dueDate: string;
  isCompleted: boolean;
  notes: string;
}

interface DiaryEntry {
  id: string;
  date: string;
  crop: string;
  activity: string;
  expense: number;
  notes: string;
}

export default function App() {
  // Navigation & View State
  const [activeTab, setActiveTab] = useState<string>('home');
  const [language, setLanguage] = useState<'hi' | 'en'>('hi'); // Default Hindi as requested
  const [isMobileFrame, setIsMobileFrame] = useState<boolean>(false);
  const [showCodeInspector, setShowCodeInspector] = useState<boolean>(false);

  // Mandi State
  const [mandiRecords, setMandiRecords] = useState<MandiRecord[]>([]);
  const [mandiLoading, setMandiLoading] = useState<boolean>(false);
  const [selectedState, setSelectedState] = useState<string>('Madhya Pradesh');
  const [selectedCommodity, setSelectedCommodity] = useState<string>('All');
  const [mandiSearch, setMandiSearch] = useState<string>('');

  // Weather State
  const [weatherData, setWeatherData] = useState<WeatherData | null>(null);
  const [weatherLoading, setWeatherLoading] = useState<boolean>(false);

  // AI Assistant Chat State
  const [messages, setMessages] = useState<ChatMessage[]>([
    {
      id: 'init_1',
      role: 'assistant',
      text: 'नमस्ते किसान भाई! मैं आपका मंडी मित्र एआई सहायक हूँ। 🌾\nअपनी फसल में किसी भी रोग, कीड़े के प्रकोप, खाद की सही मात्रा, या मंडी भाव के बारे में पूछें। आप पौधे की पत्ती की फोटो भी भेज सकते हैं या माइक दबाकर बोल सकते हैं।',
      timestamp: 'अभी',
    },
  ]);
  const [inputPrompt, setInputPrompt] = useState<string>('');
  const [attachedImage, setAttachedImage] = useState<string | null>(null);
  const [isAiTyping, setIsAiTyping] = useState<boolean>(false);
  const [isListening, setIsListening] = useState<boolean>(false);
  const chatScrollRef = useRef<HTMLDivElement>(null);

  // Fertilizer Calculator State
  const [fertCrop, setFertCrop] = useState<string>('Wheat (गेहूँ)');
  const [fertArea, setFertArea] = useState<string>('2.0');
  const [fertUnit, setFertUnit] = useState<string>('Acre');
  const [fertUreaBags, setFertUreaBags] = useState<number>(3.8);
  const [fertDapBags, setFertDapBags] = useState<number>(2.1);
  const [fertMopBags, setFertMopBags] = useState<number>(1.1);

  // Profit Calculator State
  const [profitArea, setProfitArea] = useState<number>(2);
  const [costSeed, setCostSeed] = useState<number>(3500);
  const [costFert, setCostFert] = useState<number>(5800);
  const [costLabour, setCostLabour] = useState<number>(6000);
  const [costIrrigation, setCostIrrigation] = useState<number>(2400);
  const [costMachinery, setCostMachinery] = useState<number>(4500);
  const [costOther, setCostOther] = useState<number>(1500);
  const [yieldQuintals, setYieldQuintals] = useState<number>(42);
  const [salePrice, setSalePrice] = useState<number>(2750);

  // Soil Health State
  const [soilType, setSoilType] = useState<string>('काली मिट्टी (Black Soil)');
  const [soilPh, setSoilPh] = useState<string>('7.2');
  const [soilNitrogen, setSoilNitrogen] = useState<string>('240');
  const [soilPhosphorus, setSoilPhosphorus] = useState<string>('18');
  const [soilPotash, setSoilPotash] = useState<string>('280');
  const [soilOc, setSoilOc] = useState<string>('0.54');
  const [soilIsCertified, setSoilIsCertified] = useState<boolean>(false);
  const [soilAdvice, setSoilAdvice] = useState<string>('');

  // Crop Calendar State
  const [calendarEvents, setCalendarEvents] = useState<CalendarEvent[]>([
    {
      id: 'c1',
      cropName: 'गेहूँ (Wheat)',
      activityType: 'प्रथम सिंचाई (CRI Stage - ताज मूल अवस्था)',
      dueDate: '2026-10-27',
      isCompleted: false,
      notes: 'बुवाई के 21 दिन बाद पहली सिंचाई अति आवश्यक है।',
    },
    {
      id: 'c2',
      cropName: 'गेहूँ (Wheat)',
      activityType: 'यूरिया की प्रथम टॉप ड्रेसिंग (Top Dressing)',
      dueDate: '2026-10-29',
      isCompleted: false,
      notes: 'सिंचाई के 2-3 दिन बाद 45 कि.ग्रा. यूरिया प्रति एकड़ बुरकाव करें।',
    },
    {
      id: 'c3',
      cropName: 'सरसों (Mustard)',
      activityType: 'एफिड (माहू) कीट निगरानी व नीम तेल स्प्रे',
      dueDate: '2026-11-02',
      isCompleted: true,
      notes: 'नीम तेल 1500 ppm (3-4 मिली/लीटर पानी) का छिड़काव किया।',
    },
  ]);

  // Farm Diary State
  const [diaryEntries, setDiaryEntries] = useState<DiaryEntry[]>([
    {
      id: 'd1',
      date: '2026-10-22',
      crop: 'गेहूँ',
      activity: 'सुपर सीडर से गेहूँ की बुवाई',
      expense: 3800,
      notes: '40 kg HD-2967 बीज और 50 kg DAP प्रति एकड़ डाला।',
    },
    {
      id: 'd2',
      date: '2026-10-18',
      crop: 'सोयाबीन',
      activity: 'थ्रेशर से गहाई व मंडी परिवहन',
      expense: 2600,
      notes: 'कुल 34 क्विंटल उपज प्राप्त हुई।',
    },
  ]);

  // Farmer Profile State
  const [farmerName, setFarmerName] = useState<string>('रामेश्वर पटेल');
  const [farmerPhone, setFarmerPhone] = useState<string>('+91 98765 43210');
  const [farmerState, setFarmerState] = useState<string>('Madhya Pradesh');
  const [farmerDistrict, setFarmerDistrict] = useState<string>('Indore');
  const [farmerLand, setFarmerLand] = useState<string>('5.0 एकड़');

  // Flutter Source Files for Code Explorer
  const [flutterFiles, setFlutterFiles] = useState<any[]>([]);
  const [selectedFlutterFile, setSelectedFlutterFile] = useState<any>(null);

  // Fetch initial Mandi & Weather data
  useEffect(() => {
    fetchMandiPrices();
    fetchWeather();
    fetchFlutterTree();
    calculateFertilizers();
    analyzeSoilHealth();
  }, []);

  const fetchMandiPrices = async (stateParam = selectedState, commParam = selectedCommodity) => {
    setMandiLoading(true);
    try {
      const q = new URLSearchParams();
      if (stateParam && stateParam !== 'All') q.set('state', stateParam);
      if (commParam && commParam !== 'All') q.set('commodity', commParam);
      const res = await fetch(`/api/mandi?${q.toString()}`);
      if (res.ok) {
        const data = await res.json();
        setMandiRecords(data.records || []);
      }
    } catch (e) {
      console.error(e);
    } finally {
      setMandiLoading(false);
    }
  };

  const fetchWeather = async () => {
    setWeatherLoading(true);
    try {
      const res = await fetch('/api/weather?lat=22.7196&lon=75.8577&location=Indore, Madhya Pradesh');
      if (res.ok) {
        const data = await res.json();
        setWeatherData(data);
      }
    } catch (e) {
      console.error(e);
    } finally {
      setWeatherLoading(false);
    }
  };

  const fetchFlutterTree = async () => {
    try {
      const res = await fetch('/api/flutter-files');
      if (res.ok) {
        const data = await res.json();
        setFlutterFiles(data.files || []);
        // select main.dart or pubspec.yaml by default
        const findMain = (items: any[]): any => {
          for (const it of items) {
            if (it.path === 'pubspec.yaml' || it.path.endsWith('main.dart')) return it;
            if (it.children) {
              const resChild = findMain(it.children);
              if (resChild) return resChild;
            }
          }
          return null;
        };
        const defaultFile = findMain(data.files);
        if (defaultFile) setSelectedFlutterFile(defaultFile);
      }
    } catch (_) {}
  };

  // Fertilizer calculation logic
  const calculateFertilizers = () => {
    const area = parseFloat(fertArea) || 1.0;
    let acres = area;
    if (fertUnit === 'Bigha') acres = area * 0.4;
    else if (fertUnit === 'Hectare') acres = area * 2.471;

    // Standard wheat nutrient requirement per acre: N:48, P:24, K:16
    const totalP = 24.0 * acres;
    const dap = totalP / 23.0; // 50kg DAP gives 23kg P and 9kg N
    const nFromDap = dap * 9.0;
    const remainingN = Math.max(0, 48.0 * acres - nFromDap);
    const urea = remainingN / 20.7; // 45kg Urea gives 20.7kg N
    const mop = (16.0 * acres) / 30.0; // 50kg MOP gives 30kg K

    setFertUreaBags(parseFloat(urea.toFixed(1)));
    setFertDapBags(parseFloat(dap.toFixed(1)));
    setFertMopBags(parseFloat(mop.toFixed(1)));
  };

  const analyzeSoilHealth = () => {
    const ph = parseFloat(soilPh) || 7.0;
    const oc = parseFloat(soilOc) || 0.5;
    let advice = '';

    if (ph < 6.5) {
      advice += '• मृदा अम्लीय (Acidic) है। प्रति एकड़ 200-300 कि.ग्रा. कृषि चूना (Agricultural Lime) का प्रयोग करें। ';
    } else if (ph > 8.0) {
      advice += '• मृदा क्षारीय (Alkaline) है। प्रति एकड़ 150-200 कि.ग्रा. जिप्सम (Gypsum) अथवा हरी खाद (ढैंचा/सनई) लगाएं। ';
    } else {
      advice += '• मृदा का pH मान (6.5 - 7.5) उत्कृष्ट व पोषक तत्व अवशोषण के सर्वोत्तम है। ';
    }

    if (oc < 0.5) {
      advice += '• जैविक कार्बन (OC) कम (<0.5%) है। प्रति एकड़ 2-3 ट्रॉली सड़ी गोबर खाद या वर्मीकम्पोस्ट (केंचुआ खाद) अवश्य डालें।';
    } else {
      advice += '• जैविक कार्बन का स्तर सामान्य है। सूक्ष्म जैविक उर्वरक (Azotobacter, PSB) का प्रयोग जारी रखें।';
    }
    setSoilAdvice(advice);
  };

  // AI Assistant Chat Send
  const handleSendMessage = async () => {
    if (!inputPrompt.trim() && !attachedImage) return;

    const userMsg: ChatMessage = {
      id: 'msg_' + Date.now(),
      role: 'user',
      text: inputPrompt || 'कृपया इस फसल की पत्ती का रोग पहचानें व उपचार बताएं।',
      image: attachedImage || undefined,
      timestamp: 'अभी',
    };

    setMessages((prev) => [...prev, userMsg]);
    setInputPrompt('');
    setAttachedImage(null);
    setIsAiTyping(true);

    try {
      const res = await fetch('/api/chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          prompt: userMsg.text,
          language: language,
          image: userMsg.image,
        }),
      });
      const data = await res.json();
      const aiReply: ChatMessage = {
        id: 'msg_' + (Date.now() + 1),
        role: 'assistant',
        text: data.reply || 'क्षमा करें, उत्तर प्राप्त नहीं हो सका।',
        timestamp: 'अभी',
      };
      setMessages((prev) => [...prev, aiReply]);
    } catch (err: any) {
      setMessages((prev) => [
        ...prev,
        {
          id: 'msg_' + Date.now(),
          role: 'assistant',
          text: 'सर्वर से संपर्क करने में असमर्थ। कृपया पुनः प्रयास करें।',
          timestamp: 'अभी',
        },
      ]);
    } finally {
      setIsAiTyping(false);
      chatScrollRef.current?.scrollIntoView({ behavior: 'smooth' });
    }
  };

  // Speech-to-Text (Voice Mic)
  const toggleSpeechRecognition = () => {
    const SpeechRecognition =
      (window as any).SpeechRecognition || (window as any).webkitSpeechRecognition;

    if (!SpeechRecognition) {
      alert(
        language === 'hi'
          ? 'आपके ब्राउज़र में आवाज़ पहचान (Speech Recognition) समर्थित नहीं है। कृपया लिखकर प्रश्न पूछें।'
          : 'Speech recognition is not supported in this browser. Please type your query.'
      );
      return;
    }

    if (isListening) {
      setIsListening(false);
      return;
    }

    try {
      const recognition = new SpeechRecognition();
      recognition.lang = language === 'hi' ? 'hi-IN' : 'en-IN';
      recognition.continuous = false;
      recognition.interimResults = false;

      recognition.onstart = () => setIsListening(true);
      recognition.onend = () => setIsListening(false);
      recognition.onerror = () => setIsListening(false);

      recognition.onresult = (event: any) => {
        const transcript = event.results[0][0].transcript;
        setInputPrompt(transcript);
      };

      recognition.start();
    } catch (e) {
      setIsListening(false);
    }
  };

  // Text-to-Speech (Voice Read Aloud)
  const speakText = (text: string) => {
    if (!('speechSynthesis' in window)) return;
    window.speechSynthesis.cancel();
    const utterance = new SpeechSynthesisUtterance(text);
    utterance.lang = language === 'hi' ? 'hi-IN' : 'en-US';
    utterance.rate = 0.95;
    window.speechSynthesis.speak(utterance);
  };

  // Image Upload handler
  const handleImageUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        setAttachedImage(reader.result as string);
      };
      reader.readAsDataURL(file);
    }
  };

  // Profit calculation metrics
  const totalCost = costSeed + costFert + costLabour + costIrrigation + costMachinery + costOther;
  const totalRevenue = yieldQuintals * salePrice;
  const netProfit = totalRevenue - totalCost;
  const profitPerAcre = profitArea > 0 ? netProfit / profitArea : netProfit;

  // Bilingual strings helper
  const t = (hiText: string, enText: string) => (language === 'hi' ? hiText : enText);

  return (
    <div className="min-h-screen bg-[#F4F7F4] text-gray-900 font-sans flex flex-col">
      {/* --- TOP GLOBAL NAVIGATION HEADER --- */}
      <header className="sticky top-0 z-50 bg-[#155724] text-white border-b border-emerald-900 shadow-md">
        <div className="max-w-7xl mx-auto px-4 py-3 flex items-center justify-between gap-2">
          {/* Brand */}
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-tr from-[#EAA023] to-amber-300 flex items-center justify-center shadow text-emerald-950 font-bold text-xl">
              🌾
            </div>
            <div>
              <div className="flex items-center gap-2">
                <h1 className="text-lg md:text-xl font-bold tracking-tight">
                  Mandi Mitra AI
                </h1>
                <span className="hidden sm:inline-block px-2 py-0.5 text-xs bg-amber-400 text-emerald-950 rounded-full font-semibold">
                  स्मार्ट किसान
                </span>
              </div>
              <p className="text-xs text-emerald-200 hidden sm:block">
                {t('भारतीय किसान का सच्चा डिजिटल साथी', 'Smart Agriculture AI Platform for Indian Farmers')}
              </p>
            </div>
          </div>

          {/* Action Tools: Download Flutter ZIP, Language Switcher, View Switcher */}
          <div className="flex items-center gap-2">
            {/* Download Flutter ZIP Button */}
            <a
              href="/api/download-flutter-zip"
              download="mandi_mitra_ai_flutter.zip"
              className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-[#EAA023] hover:bg-amber-400 text-emerald-950 font-bold text-xs sm:text-sm shadow-md transition-all active:scale-95"
              title="Download Complete Production Flutter & Dart Codebase (.ZIP)"
            >
              <Download className="w-4 h-4" />
              <span className="hidden md:inline">Download Flutter Project</span>
              <span className="md:hidden">Flutter .ZIP</span>
            </a>

            {/* Flutter Code Explorer Toggle */}
            <button
              onClick={() => setShowCodeInspector(!showCodeInspector)}
              className={`inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold border transition-all ${
                showCodeInspector
                  ? 'bg-white text-emerald-900 border-white'
                  : 'bg-emerald-800/80 hover:bg-emerald-700 text-white border-emerald-600'
              }`}
            >
              <Code2 className="w-4 h-4" />
              <span className="hidden sm:inline">Dart Code Explorer</span>
            </button>

            {/* Language Toggle */}
            <button
              onClick={() => setLanguage(language === 'hi' ? 'en' : 'hi')}
              className="px-2.5 py-1.5 rounded-lg bg-emerald-800/70 hover:bg-emerald-700 text-xs font-bold border border-emerald-600 flex items-center gap-1"
            >
              <span>{language === 'hi' ? '🇮🇳 हिन्दी' : '🇬🇧 English'}</span>
            </button>

            {/* Mobile / Desktop frame toggle */}
            <button
              onClick={() => setIsMobileFrame(!isMobileFrame)}
              className="p-1.5 rounded-lg bg-emerald-800/70 hover:bg-emerald-700 text-emerald-100 border border-emerald-600 hidden lg:flex items-center"
              title={isMobileFrame ? 'Switch to Full Dashboard' : 'Preview as Android Phone UI'}
            >
              {isMobileFrame ? <Monitor className="w-4 h-4" /> : <Smartphone className="w-4 h-4" />}
            </button>
          </div>
        </div>
      </header>

      {/* --- FLUTTER DART CODE INSPECTOR MODAL / DRAWER --- */}
      {showCodeInspector && (
        <div className="bg-slate-900 text-slate-100 border-b border-slate-700 p-4 shadow-2xl transition-all">
          <div className="max-w-7xl mx-auto">
            <div className="flex items-center justify-between mb-3 pb-2 border-b border-slate-800">
              <div className="flex items-center gap-2">
                <FileCode className="w-5 h-5 text-amber-400" />
                <h2 className="font-bold text-sm md:text-base text-amber-400">
                  Genuine Flutter & Dart Source Code Viewer (100% Complete Project Structure)
                </h2>
              </div>
              <div className="flex items-center gap-3">
                <span className="text-xs text-slate-400">
                  Includes pubspec.yaml, main.dart, 14 screen modules & Android/iOS configs
                </span>
                <button
                  onClick={() => setShowCodeInspector(false)}
                  className="text-xs px-2 py-1 bg-slate-800 hover:bg-slate-700 text-slate-300 rounded"
                >
                  Close
                </button>
              </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-4 gap-4 max-h-96">
              {/* File Tree Column */}
              <div className="md:col-span-1 bg-slate-950 p-3 rounded-lg border border-slate-800 overflow-y-auto text-xs space-y-1 font-mono">
                <div className="font-bold text-slate-400 mb-2 flex items-center gap-1">
                  <Folder className="w-4 h-4 text-amber-400" /> mandi_mitra_ai/
                </div>
                {function renderTree(nodes: any[], depth = 0): React.ReactNode {
                  return nodes.map((node) => (
                    <div key={node.path} style={{ paddingLeft: `${depth * 12}px` }}>
                      {node.isDirectory ? (
                        <div className="text-slate-400 flex items-center gap-1.5 py-0.5">
                          <Folder className="w-3.5 h-3.5 text-amber-500/80" />
                          <span>{node.name}/</span>
                        </div>
                      ) : (
                        <button
                          onClick={() => setSelectedFlutterFile(node)}
                          className={`w-full text-left flex items-center gap-1.5 py-1 px-1.5 rounded transition ${
                            selectedFlutterFile?.path === node.path
                              ? 'bg-emerald-600 text-white font-bold'
                              : 'text-slate-300 hover:bg-slate-800'
                          }`}
                        >
                          <FileCode className="w-3.5 h-3.5 text-sky-400" />
                          <span className="truncate">{node.name}</span>
                        </button>
                      )}
                      {node.children && renderTree(node.children, depth + 1)}
                    </div>
                  ));
                }(flutterFiles)}
              </div>

              {/* Code Viewer Column */}
              <div className="md:col-span-3 bg-slate-950 p-3 rounded-lg border border-slate-800 flex flex-col">
                <div className="flex items-center justify-between pb-2 mb-2 border-b border-slate-800 text-xs text-slate-400 font-mono">
                  <span>
                    Viewing: <strong className="text-emerald-400">{selectedFlutterFile?.path || 'pubspec.yaml'}</strong>
                  </span>
                  <a
                    href="/api/download-flutter-zip"
                    className="text-amber-400 hover:underline flex items-center gap-1"
                  >
                    <Download className="w-3 h-3" /> Download Entire Project ZIP
                  </a>
                </div>
                <pre className="flex-1 overflow-auto p-2 text-xs font-mono text-emerald-300 leading-relaxed max-h-72 select-all bg-black/40 rounded">
                  {selectedFlutterFile?.content || '// Select a Dart file on the left to inspect its source code'}
                </pre>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* --- MAIN APP CONTAINER (Supports Desktop or Android Smartphone Frame) --- */}
      <main className="flex-1 flex justify-center py-4 px-2 sm:px-4">
        <div
          className={`w-full transition-all duration-300 ${
            isMobileFrame
              ? 'max-w-md bg-white border-8 border-gray-800 rounded-[42px] shadow-2xl overflow-hidden flex flex-col h-[850px] relative'
              : 'max-w-7xl'
          }`}
        >
          {/* Mobile frame simulated notch and status bar */}
          {isMobileFrame && (
            <div className="bg-[#155724] text-white px-6 pt-2 pb-1 text-xs flex justify-between items-center select-none">
              <span className="font-semibold">9:41</span>
              <div className="w-20 h-4 bg-gray-900 rounded-full mx-auto" />
              <div className="flex items-center gap-1">
                <span>5G</span>
                <span>100%</span>
              </div>
            </div>
          )}

          {/* Core Body Layout: Sidebar Navigation (on Desktop) + Main Content View */}
          <div className="flex flex-1 overflow-hidden">
            {/* Desktop Navigation Sidebar */}
            {!isMobileFrame && (
              <aside className="w-64 bg-white border-r border-gray-200 hidden md:flex flex-col justify-between p-4 shadow-sm">
                <div className="space-y-1">
                  <div className="px-3 py-2 text-xs font-bold text-gray-400 uppercase tracking-wider">
                    {t('मुख्य सेवाएं', 'Core Modules')}
                  </div>
                  {[
                    { id: 'home', icon: Sprout, label: t('होम डैशबोर्ड', 'Home Dashboard') },
                    { id: 'mandi', icon: TrendingUp, label: t('लाइव मंडी भाव', 'Live Mandi Prices') },
                    { id: 'weather', icon: CloudSun, label: t('मौसम व सलाह', 'Agro Weather') },
                    { id: 'ai', icon: Bot, label: t('एआई कृषि मित्र', 'AI Crop Assistant') },
                    { id: 'fertilizer', icon: FlaskConical, label: t('खाद कैलकुलेटर', 'Fertilizer Dosage') },
                    { id: 'soil', icon: Calculator, label: t('मृदा स्वास्थ्य', 'Soil Health') },
                    { id: 'calendar', icon: Calendar, label: t('फसल कैलेंडर', 'Crop Calendar') },
                    { id: 'profit', icon: DollarSign, label: t('मुनाफा कैलकुलेटर', 'Profit Calculator') },
                    { id: 'schemes', icon: Landmark, label: t('सरकारी योजनाएं', 'Govt Schemes') },
                    { id: 'machinery', icon: Tractor, label: t('यंत्र किराया', 'Machinery Rental') },
                    { id: 'marketplace', icon: Store, label: t('फसल बाज़ार', 'Crop Marketplace') },
                    { id: 'community', icon: Users, label: t('किसान चौपाल', 'Kisan Community') },
                    { id: 'diary', icon: BookOpen, label: t('कृषि दैनिकी', 'Farm Diary') },
                    { id: 'profile', icon: User, label: t('किसान प्रोफ़ाइल', 'Farmer Profile') },
                  ].map((item) => {
                    const Icon = item.icon;
                    const isActive = activeTab === item.id;
                    return (
                      <button
                        key={item.id}
                        onClick={() => setActiveTab(item.id)}
                        className={`w-full flex items-center gap-3 px-3 py-2.5 rounded-xl font-medium text-sm transition-all text-left ${
                          isActive
                            ? 'bg-[#1E7E34] text-white shadow-sm font-bold'
                            : 'text-gray-700 hover:bg-emerald-50 hover:text-[#1E7E34]'
                        }`}
                      >
                        <Icon className={`w-4 h-4 ${isActive ? 'text-white' : 'text-[#1E7E34]'}`} />
                        <span>{item.label}</span>
                      </button>
                    );
                  })}
                </div>

                {/* Farmer mini badge */}
                <div className="pt-4 border-t border-gray-100 flex items-center gap-3">
                  <div className="w-10 h-10 rounded-full bg-emerald-100 border border-emerald-300 flex items-center justify-center text-[#1E7E34] font-bold">
                    RP
                  </div>
                  <div className="truncate">
                    <p className="text-xs font-bold text-gray-800">{farmerName}</p>
                    <p className="text-[11px] text-gray-500">{farmerDistrict}, {farmerState}</p>
                  </div>
                </div>
              </aside>
            )}

            {/* Tab Contents Viewport */}
            <div className="flex-1 overflow-y-auto p-4 md:p-6 space-y-6">
              {/* ================= TAB 1: HOME DASHBOARD ================= */}
              {activeTab === 'home' && (
                <div className="space-y-6">
                  {/* Farmer Welcome Banner */}
                  <div className="bg-gradient-to-r from-[#155724] to-[#1E7E34] rounded-2xl p-5 text-white shadow-lg relative overflow-hidden">
                    <div className="relative z-10">
                      <div className="flex items-center gap-2 mb-1">
                        <span className="px-2.5 py-0.5 rounded-full bg-amber-400 text-emerald-950 text-xs font-bold">
                          {t('स्वागतम्', 'Welcome')}
                        </span>
                        <span className="text-xs text-emerald-200">
                          {new Date().toLocaleDateString(language === 'hi' ? 'hi-IN' : 'en-IN', {
                            weekday: 'long',
                            day: 'numeric',
                            month: 'long',
                            year: 'numeric',
                          })}
                        </span>
                      </div>
                      <h2 className="text-xl md:text-2xl font-bold">
                        {t(`राम राम किसान भाई, ${farmerName} जी! 🙏`, `Welcome, Respected Farmer ${farmerName}! 🙏`)}
                      </h2>
                      <p className="text-xs md:text-sm text-emerald-100 mt-1 max-w-xl">
                        {t(
                          'आज आपके क्षेत्र में मौसम अनुकूल है। रबी फसलों में पहली सिंचाई व यूरिया टॉप ड्रेसिंग का उपयुक्त समय है।',
                          'Weather is clear today. Ideal window for first irrigation and nitrogen top-dressing in rabi crops.'
                        )}
                      </p>
                    </div>
                  </div>

                  {/* Weather & Quick Stats Grid */}
                  <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                    {/* Live Agro-Weather Card */}
                    <div className="bg-gradient-to-br from-emerald-800 to-teal-900 rounded-2xl p-5 text-white shadow-md flex flex-col justify-between">
                      <div className="flex justify-between items-start">
                        <div>
                          <div className="flex items-center gap-1.5 text-xs text-emerald-200 mb-1">
                            <MapPin className="w-3.5 h-3.5 text-amber-300" />
                            <span>{weatherData?.locationName || 'Indore, MP'}</span>
                          </div>
                          <h3 className="text-3xl font-black">
                            {weatherData ? Math.round(weatherData.temperature) : '28'}°C
                          </h3>
                          <p className="text-xs text-emerald-100 font-medium mt-0.5">
                            {weatherData?.conditionText || 'साफ़ मौसम (Clear Sky)'}
                          </p>
                        </div>
                        <CloudSun className="w-10 h-10 text-amber-300 animate-pulse" />
                      </div>

                      <div className="grid grid-cols-3 gap-2 my-4 pt-3 border-t border-emerald-700/60 text-center text-xs">
                        <div>
                          <p className="text-emerald-300 text-[10px]">{t('नमी', 'Humidity')}</p>
                          <p className="font-bold">{weatherData?.relativeHumidity ?? 60}%</p>
                        </div>
                        <div>
                          <p className="text-emerald-300 text-[10px]">{t('बारिश', 'Rain')}</p>
                          <p className="font-bold">{weatherData?.precipitationProbability ?? 10}%</p>
                        </div>
                        <div>
                          <p className="text-emerald-300 text-[10px]">{t('हवा', 'Wind')}</p>
                          <p className="font-bold">{weatherData?.windSpeed ?? 11} km/h</p>
                        </div>
                      </div>

                      <div className="bg-emerald-950/40 rounded-xl p-2.5 text-[11px] text-emerald-100 flex items-start gap-2">
                        <Sparkles className="w-4 h-4 text-amber-300 shrink-0 mt-0.5" />
                        <span>{weatherData?.agroAdvisory || 'मौसम शांत है। कीटनाशक स्प्रे के लिए अनुकूल समय है।'}</span>
                      </div>
                    </div>

                    {/* Today's Top Mandi Rate Banner */}
                    <div className="bg-white rounded-2xl p-5 border border-gray-200 shadow-sm flex flex-col justify-between">
                      <div>
                        <div className="flex items-center justify-between mb-2">
                          <span className="text-xs font-bold text-gray-500 uppercase tracking-wide">
                            {t('आज का शीर्ष भाव', "Today's Mandi Top Rate")}
                          </span>
                          <span className="px-2 py-0.5 text-[10px] font-bold bg-green-100 text-green-800 rounded-full flex items-center gap-0.5">
                            <ArrowUpRight className="w-3 h-3" /> +₹60
                          </span>
                        </div>
                        <h4 className="text-lg font-bold text-gray-800">
                          {t('गेहूँ (Lokwan Wheat)', 'Wheat (Lokwan)')}
                        </h4>
                        <p className="text-xs text-gray-500">
                          {t('इंदौर मंडी (लक्ष्मीबाई नगर)', 'Indore Mandi Market')}
                        </p>
                        <div className="mt-3">
                          <span className="text-2xl font-black text-[#1E7E34]">₹2,750</span>
                          <span className="text-xs text-gray-500 ml-1">/ {t('क्विंटल', 'Quintal')}</span>
                        </div>
                      </div>
                      <button
                        onClick={() => setActiveTab('mandi')}
                        className="mt-4 text-xs font-bold text-[#1E7E34] hover:underline flex items-center justify-between py-2 border-t border-gray-100"
                      >
                        <span>{t('सभी 15 मंडियों के भाव देखें', 'View All 15 Mandi Rates')}</span>
                        <ChevronRight className="w-4 h-4" />
                      </button>
                    </div>

                    {/* AI Prompt Shortcut Card */}
                    <div className="bg-gradient-to-br from-amber-50 to-orange-50 rounded-2xl p-5 border border-amber-200 shadow-sm flex flex-col justify-between">
                      <div>
                        <div className="w-9 h-9 rounded-xl bg-amber-400 text-emerald-950 flex items-center justify-center font-bold mb-3 shadow">
                          <Bot className="w-5 h-5" />
                        </div>
                        <h4 className="text-base font-bold text-gray-900">
                          {t('फसल रोग व खाद परामर्श', 'Crop Health & Disease AI')}
                        </h4>
                        <p className="text-xs text-gray-600 mt-1">
                          {t(
                            'पत्ती की फोटो अपलोड करें या बोलकर पूछें। वैज्ञानिक उपचार तुरंत जानें।',
                            'Upload leaf photo or ask by voice. Get verified agronomist solutions.'
                          )}
                        </p>
                      </div>
                      <button
                        onClick={() => setActiveTab('ai')}
                        className="mt-4 w-full py-2.5 px-3 bg-[#1E7E34] hover:bg-[#155724] text-white text-xs font-bold rounded-xl shadow transition flex items-center justify-center gap-1.5"
                      >
                        <Mic className="w-3.5 h-3.5 text-amber-300" />
                        <span>{t('एआई सहायक से पूछें', 'Ask AI Farming Assistant')}</span>
                      </button>
                    </div>
                  </div>

                  {/* 8 Core Feature Quick Actions */}
                  <div>
                    <h3 className="text-base font-bold text-gray-800 mb-3 flex items-center gap-2">
                      <Sprout className="w-4 h-4 text-[#1E7E34]" />
                      <span>{t('किसान सेवा केंद्र (Quick Actions)', 'Farmer Hub Quick Actions')}</span>
                    </h3>
                    <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
                      {[
                        { id: 'mandi', label: t('लाइव मंडी भाव', 'Mandi Rates'), icon: TrendingUp, color: 'text-emerald-700 bg-emerald-50' },
                        { id: 'fertilizer', label: t('खाद कैलकुलेटर', 'Fertilizer Calc'), icon: FlaskConical, color: 'text-teal-700 bg-teal-50' },
                        { id: 'soil', label: t('मृदा स्वास्थ्य', 'Soil Health'), icon: Calculator, color: 'text-amber-700 bg-amber-50' },
                        { id: 'calendar', label: t('फसल कैलेंडर', 'Crop Calendar'), icon: Calendar, color: 'text-blue-700 bg-blue-50' },
                        { id: 'profit', label: t('मुनाफा कैलकुलेटर', 'Profit Calc'), icon: DollarSign, color: 'text-green-700 bg-green-50' },
                        { id: 'schemes', label: t('सरकारी योजनाएं', 'Govt Schemes'), icon: Landmark, color: 'text-indigo-700 bg-indigo-50' },
                        { id: 'machinery', label: t('यंत्र किराया', 'Tractor Rental'), icon: Tractor, color: 'text-orange-700 bg-orange-50' },
                        { id: 'marketplace', label: t('फसल बाज़ार', 'Crop Market'), icon: Store, color: 'text-rose-700 bg-rose-50' },
                      ].map((action) => {
                        const Icon = action.icon;
                        return (
                          <button
                            key={action.id}
                            onClick={() => setActiveTab(action.id)}
                            className="bg-white p-3.5 rounded-2xl border border-gray-200 hover:border-emerald-500 hover:shadow-md transition text-left flex items-center gap-3 group"
                          >
                            <div className={`p-2.5 rounded-xl ${action.color} group-hover:scale-105 transition`}>
                              <Icon className="w-5 h-5" />
                            </div>
                            <span className="text-xs sm:text-sm font-bold text-gray-800 group-hover:text-[#1E7E34]">
                              {action.label}
                            </span>
                          </button>
                        );
                      })}
                    </div>
                  </div>

                  {/* Upcoming Farming Tasks Alert */}
                  <div className="bg-white rounded-2xl p-5 border border-gray-200 shadow-sm">
                    <div className="flex items-center justify-between mb-3">
                      <h3 className="font-bold text-sm text-gray-800 flex items-center gap-2">
                        <Calendar className="w-4 h-4 text-[#1E7E34]" />
                        <span>{t('आगामी कृषि कार्य व रिमाइंडर', 'Upcoming Farm Reminders')}</span>
                      </h3>
                      <button
                        onClick={() => setActiveTab('calendar')}
                        className="text-xs text-[#1E7E34] font-bold hover:underline"
                      >
                        {t('कैलेंडर प्रबंधित करें', 'Manage Calendar')}
                      </button>
                    </div>
                    <div className="space-y-2.5">
                      {calendarEvents.slice(0, 2).map((ev) => (
                        <div
                          key={ev.id}
                          className="flex items-center justify-between p-3 rounded-xl bg-gray-50 border border-gray-100"
                        >
                          <div className="flex items-center gap-3">
                            <span className="px-2 py-0.5 bg-emerald-100 text-[#1E7E34] text-[11px] font-bold rounded">
                              {ev.cropName}
                            </span>
                            <div>
                              <p className="text-xs font-bold text-gray-800">{ev.activityType}</p>
                              <p className="text-[11px] text-gray-500">{ev.notes}</p>
                            </div>
                          </div>
                          <span className="text-xs font-semibold text-gray-600 bg-white px-2.5 py-1 rounded-md border border-gray-200 shadow-xs">
                            {ev.dueDate}
                          </span>
                        </div>
                      ))}
                    </div>
                  </div>
                </div>
              )}

              {/* ================= TAB 2: LIVE MANDI PRICES ================= */}
              {activeTab === 'mandi' && (
                <div className="space-y-5">
                  <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                    <div>
                      <h2 className="text-xl font-bold text-gray-900 flex items-center gap-2">
                        <TrendingUp className="w-5 h-5 text-[#1E7E34]" />
                        <span>{t('लाइव कृषि उपज मंडी भाव', 'Live Agricultural Market Prices')}</span>
                      </h2>
                      <p className="text-xs text-gray-500">
                        {t(
                          'भारत सरकार agmarknet / data.gov.in बेंचमार्क दरों पर आधारित ताज़ा भाव।',
                          'Real-time rates based on official Indian agmarknet market benchmarks.'
                        )}
                      </p>
                    </div>
                    <button
                      onClick={() => fetchMandiPrices()}
                      className="inline-flex items-center gap-1.5 px-3 py-1.5 bg-[#1E7E34] text-white text-xs font-bold rounded-lg hover:bg-[#155724] shadow-xs"
                    >
                      <RefreshCw className={`w-3.5 h-3.5 ${mandiLoading ? 'animate-spin' : ''}`} />
                      <span>{t('रिफ्रेश भाव', 'Refresh Rates')}</span>
                    </button>
                  </div>

                  {/* Filters: State, Commodity, Search Bar */}
                  <div className="bg-white p-4 rounded-2xl border border-gray-200 shadow-sm space-y-3">
                    <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                      <div>
                        <label className="block text-xs font-bold text-gray-700 mb-1">
                          {t('राज्य चुनें', 'Select State')}
                        </label>
                        <select
                          value={selectedState}
                          onChange={(e) => {
                            setSelectedState(e.target.value);
                            fetchMandiPrices(e.target.value, selectedCommodity);
                          }}
                          className="w-full text-xs bg-gray-50 border border-gray-300 rounded-xl px-3 py-2 focus:ring-2 focus:ring-emerald-500"
                        >
                          {['All', 'Madhya Pradesh', 'Punjab', 'Haryana', 'Rajasthan', 'Uttar Pradesh', 'Maharashtra', 'Gujarat'].map((s) => (
                            <option key={s} value={s}>{s}</option>
                          ))}
                        </select>
                      </div>

                      <div>
                        <label className="block text-xs font-bold text-gray-700 mb-1">
                          {t('फसल / जिंस', 'Crop / Commodity')}
                        </label>
                        <select
                          value={selectedCommodity}
                          onChange={(e) => {
                            setSelectedCommodity(e.target.value);
                            fetchMandiPrices(selectedState, e.target.value);
                          }}
                          className="w-full text-xs bg-gray-50 border border-gray-300 rounded-xl px-3 py-2 focus:ring-2 focus:ring-emerald-500"
                        >
                          {[
                            'All',
                            'Wheat (गेहूँ)',
                            'Paddy (धान)',
                            'Soybean (सोयाबीन)',
                            'Mustard (सरसों)',
                            'Cotton (कपास)',
                            'Gram (चना)',
                            'Onion (प्याज़)',
                            'Potato (आलू)',
                            'Tomato (टमाटर)',
                          ].map((c) => (
                            <option key={c} value={c}>{c}</option>
                          ))}
                        </select>
                      </div>

                      <div>
                        <label className="block text-xs font-bold text-gray-700 mb-1">
                          {t('मंडी या जिला खोजें', 'Search Mandi or District')}
                        </label>
                        <div className="relative">
                          <Search className="w-3.5 h-3.5 text-gray-400 absolute left-3 top-2.5" />
                          <input
                            type="text"
                            value={mandiSearch}
                            onChange={(e) => setMandiSearch(e.target.value)}
                            placeholder={t('उदा. इंदौर, खन्ना, कोटा...', 'e.g. Indore, Khanna, Kota...')}
                            className="w-full text-xs bg-gray-50 border border-gray-300 rounded-xl pl-8 pr-3 py-2 focus:ring-2 focus:ring-emerald-500"
                          />
                        </div>
                      </div>
                    </div>
                  </div>

                  {/* Mandi Records Grid */}
                  {mandiLoading ? (
                    <div className="py-12 text-center text-gray-400">
                      <RefreshCw className="w-8 h-8 animate-spin mx-auto text-[#1E7E34] mb-2" />
                      <p className="text-xs">{t('मंडी भाव लोड हो रहे हैं...', 'Fetching live mandi rates...')}</p>
                    </div>
                  ) : mandiRecords.length === 0 ? (
                    <div className="py-12 text-center text-gray-400 bg-white rounded-2xl border border-gray-200">
                      <AlertCircle className="w-8 h-8 mx-auto text-amber-500 mb-2" />
                      <p className="text-sm font-bold text-gray-700">{t('कोई रिकॉर्ड नहीं मिला', 'No Mandi Records Found')}</p>
                      <p className="text-xs text-gray-400 mt-1">{t('कृपया अन्य राज्य या फसल का चयन करें।', 'Try selecting another state or commodity.')}</p>
                    </div>
                  ) : (
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                      {mandiRecords
                        .filter((r) => {
                          const q = mandiSearch.toLowerCase();
                          return (
                            !q ||
                            r.commodity.toLowerCase().includes(q) ||
                            r.market.toLowerCase().includes(q) ||
                            r.district.toLowerCase().includes(q)
                          );
                        })
                        .map((record) => (
                          <div
                            key={record.id}
                            className="bg-white rounded-2xl p-4 border border-gray-200 shadow-sm hover:shadow-md transition flex flex-col justify-between"
                          >
                            <div>
                              <div className="flex items-start justify-between">
                                <h3 className="font-bold text-sm text-gray-900 leading-tight">
                                  {record.commodity}
                                </h3>
                                <span
                                  className={`px-2 py-0.5 text-[10px] font-bold rounded-full flex items-center gap-0.5 ${
                                    record.trend === 'up'
                                      ? 'bg-green-100 text-green-800'
                                      : record.trend === 'down'
                                      ? 'bg-rose-100 text-rose-800'
                                      : 'bg-gray-100 text-gray-700'
                                  }`}
                                >
                                  {record.trend === 'up' && <ArrowUpRight className="w-3 h-3" />}
                                  {record.trend === 'down' && <ArrowDownRight className="w-3 h-3" />}
                                  <span>{record.trend === 'up' ? t('तेज़', 'Up') : record.trend === 'down' ? t('मंदा', 'Down') : t('स्थिर', 'Stable')}</span>
                                </span>
                              </div>
                              <p className="text-xs text-gray-600 font-medium mt-1">
                                {record.market}, {record.district} ({record.state})
                              </p>
                              <p className="text-[11px] text-gray-400">
                                {t('किस्म', 'Variety')}: {record.variety}
                              </p>
                            </div>

                            <div className="mt-4 pt-3 border-t border-gray-100 bg-emerald-50/50 p-2.5 rounded-xl">
                              <div className="flex justify-between items-end">
                                <div>
                                  <p className="text-[10px] text-gray-500 font-medium uppercase tracking-wider">
                                    {t('मॉडल भाव (Modal Price)', 'Modal Price')}
                                  </p>
                                  <p className="text-xl font-black text-[#1E7E34]">
                                    ₹{record.modalPrice.toLocaleString('en-IN')}
                                    <span className="text-xs font-normal text-gray-600"> /qtl</span>
                                  </p>
                                </div>
                                <div className="text-right text-[11px] text-gray-500">
                                  <span>{t('न्यूनतम - अधिकतम', 'Min - Max')}: </span>
                                  <span className="font-bold text-gray-800">
                                    ₹{record.minPrice} - ₹{record.maxPrice}
                                  </span>
                                </div>
                              </div>
                            </div>
                          </div>
                        ))}
                    </div>
                  )}
                </div>
              )}

              {/* ================= TAB 3: AGRO-WEATHER FORECAST ================= */}
              {activeTab === 'weather' && (
                <div className="space-y-6">
                  <div>
                    <h2 className="text-xl font-bold text-gray-900 flex items-center gap-2">
                      <CloudSun className="w-5 h-5 text-[#1E7E34]" />
                      <span>{t('मौसम का हाल व कृषि मौसम सलाह', 'Agro-Weather Forecast & Farm Advisory')}</span>
                    </h2>
                    <p className="text-xs text-gray-500">
                      {t('ओपन-मेटियो (Open-Meteo) लाइव सैटेलाइट डेटा एवं सटीक 7-दिवसीय पूर्वानुमान।', 'Powered by Open-Meteo satellite weather API.')}
                    </p>
                  </div>

                  {/* Main Weather Widget */}
                  {weatherData && (
                    <div className="bg-gradient-to-br from-[#155724] to-teal-900 rounded-3xl p-6 text-white shadow-xl">
                      <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
                        <div>
                          <div className="flex items-center gap-1.5 text-emerald-200 text-xs mb-1">
                            <MapPin className="w-4 h-4 text-amber-300" />
                            <span className="font-semibold">{weatherData.locationName}</span>
                          </div>
                          <div className="flex items-baseline gap-3">
                            <span className="text-5xl md:text-6xl font-black tracking-tight">
                              {Math.round(weatherData.temperature)}°
                            </span>
                            <span className="text-xl text-emerald-200">C</span>
                            <span className="text-base text-emerald-100 font-medium">
                              {weatherData.conditionText}
                            </span>
                          </div>
                          <p className="text-xs text-emerald-300 mt-1">
                            {t('महसूस तापमान', 'Feels like')}: {Math.round(weatherData.apparentTemperature)}°C
                          </p>
                        </div>

                        <div className="grid grid-cols-3 gap-4 bg-white/10 backdrop-blur-md p-4 rounded-2xl border border-white/20 text-center text-xs">
                          <div>
                            <p className="text-emerald-200 text-[10px]">{t('सापेक्ष आर्द्रता', 'Humidity')}</p>
                            <p className="text-lg font-bold">{weatherData.relativeHumidity}%</p>
                          </div>
                          <div>
                            <p className="text-emerald-200 text-[10px]">{t('वर्षा संभावना', 'Rain Chance')}</p>
                            <p className="text-lg font-bold">{weatherData.precipitationProbability}%</p>
                          </div>
                          <div>
                            <p className="text-emerald-200 text-[10px]">{t('वायु वेग', 'Wind Speed')}</p>
                            <p className="text-lg font-bold">{weatherData.windSpeed} km/h</p>
                          </div>
                        </div>
                      </div>

                      {/* Agro Advisory Callout */}
                      <div className="mt-6 p-4 rounded-2xl bg-emerald-950/60 border border-emerald-500/30 flex items-start gap-3">
                        <Sparkles className="w-5 h-5 text-amber-300 shrink-0 mt-0.5" />
                        <div>
                          <h4 className="font-bold text-xs text-amber-300 mb-1">
                            {t('विशेष कृषि परामर्श (Agro Advisory):', 'Expert Farm Advisory:')}
                          </h4>
                          <p className="text-xs text-emerald-100 leading-relaxed">
                            {weatherData.agroAdvisory}
                          </p>
                        </div>
                      </div>
                    </div>
                  )}

                  {/* 7-Day Forecast Row */}
                  <div>
                    <h3 className="text-sm font-bold text-gray-800 mb-3">
                      {t('7 दिनों का विस्तृत पूर्वानुमान', '7-Day Detailed Forecast')}
                    </h3>
                    <div className="grid grid-cols-2 sm:grid-cols-4 md:grid-cols-7 gap-2.5">
                      {weatherData?.dailyForecasts?.map((df, i) => (
                        <div
                          key={i}
                          className="bg-white p-3 rounded-xl border border-gray-200 shadow-xs text-center flex flex-col justify-between"
                        >
                          <p className="text-xs font-bold text-gray-700">{df.dayName}</p>
                          <p className="text-[10px] text-gray-400">{df.date.slice(5)}</p>
                          <div className="my-2">
                            <CloudSun className="w-6 h-6 text-amber-400 mx-auto" />
                          </div>
                          <p className="text-xs font-bold text-gray-800">
                            {Math.round(df.maxTemp)}° / {Math.round(df.minTemp)}°
                          </p>
                          <p className="text-[10px] text-blue-600 font-semibold mt-1">
                            {t('बारिश', 'Rain')} {Math.round(df.rainChance)}%
                          </p>
                        </div>
                      ))}
                    </div>
                  </div>
                </div>
              )}

              {/* ================= TAB 4: GEMINI AI FARMING ASSISTANT ================= */}
              {activeTab === 'ai' && (
                <div className="bg-white rounded-2xl border border-gray-200 shadow-sm flex flex-col h-[650px] overflow-hidden">
                  {/* Chat Header */}
                  <div className="p-4 bg-gradient-to-r from-[#155724] to-[#1E7E34] text-white flex items-center justify-between">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-xl bg-amber-400 text-emerald-950 flex items-center justify-center font-bold">
                        <Bot className="w-6 h-6" />
                      </div>
                      <div>
                        <h3 className="font-bold text-sm md:text-base flex items-center gap-1.5">
                          <span>{t('मंडी मित्र एआई सहायक', 'Mandi Mitra AI Assistant')}</span>
                          <span className="w-2 h-2 rounded-full bg-emerald-300 animate-ping" />
                        </h3>
                        <p className="text-xs text-emerald-200">
                          {t('कृषि वैज्ञानिक सलाह • रोग निदान • खाद व सिंचाई', 'Crop Disease • Agronomy • Fertilizer Advice')}
                        </p>
                      </div>
                    </div>
                    <button
                      onClick={() =>
                        setMessages([
                          {
                            id: 'reset',
                            role: 'assistant',
                            text: 'चर्चा रीसेट कर दी गई है। आप अपनी फसल संबंधित कोई भी नया प्रश्न पूछ सकते हैं।',
                            timestamp: 'अभी',
                          },
                        ])
                      }
                      className="text-xs px-2.5 py-1 bg-white/20 hover:bg-white/30 rounded-lg text-white"
                    >
                      {t('नई चर्चा', 'New Chat')}
                    </button>
                  </div>

                  {/* Chat Messages Body */}
                  <div className="flex-1 overflow-y-auto p-4 space-y-3 bg-[#F9FAF9]">
                    {messages.map((msg) => (
                      <div
                        key={msg.id}
                        className={`flex flex-col ${msg.role === 'user' ? 'items-end' : 'items-start'}`}
                      >
                        <div
                          className={`max-w-[85%] rounded-2xl p-3.5 text-xs md:text-sm leading-relaxed shadow-xs ${
                            msg.role === 'user'
                              ? 'bg-[#1E7E34] text-white rounded-br-none'
                              : 'bg-white text-gray-800 border border-gray-200 rounded-bl-none'
                          }`}
                        >
                          {msg.image && (
                            <img
                              src={msg.image}
                              alt="Crop leaf"
                              className="w-full max-h-52 object-cover rounded-lg mb-2 border border-black/10"
                            />
                          )}
                          <div className="whitespace-pre-line">{msg.text}</div>
                        </div>

                        {/* Read-Aloud Voice Button for AI messages */}
                        {msg.role === 'assistant' && (
                          <button
                            onClick={() => speakText(msg.text)}
                            className="mt-1 flex items-center gap-1 text-[11px] text-[#1E7E34] font-semibold hover:underline px-1"
                            title="Listen to this response in voice"
                          >
                            <Volume2 className="w-3.5 h-3.5" />
                            <span>{t('आवाज़ में सुनें', 'Listen Audio')}</span>
                          </button>
                        )}
                      </div>
                    ))}

                    {isAiTyping && (
                      <div className="flex items-center gap-2 p-3 bg-white rounded-xl border border-gray-200 text-xs text-gray-500 max-w-xs">
                        <RefreshCw className="w-3.5 h-3.5 animate-spin text-[#1E7E34]" />
                        <span>{t('एआई मित्र उत्तर तैयार कर रहा है...', 'AI Agronomist is analyzing...')}</span>
                      </div>
                    )}
                    <div ref={chatScrollRef} />
                  </div>

                  {/* Attached photo preview */}
                  {attachedImage && (
                    <div className="p-2 bg-emerald-50 border-t border-emerald-200 flex items-center justify-between text-xs">
                      <div className="flex items-center gap-2">
                        <img src={attachedImage} alt="Crop" className="w-10 h-10 object-cover rounded" />
                        <span className="font-semibold text-emerald-900">
                          {t('फसल की फोटो संलग्न है (रोग जांच होगी)', 'Crop photo attached for diagnosis')}
                        </span>
                      </div>
                      <button
                        onClick={() => setAttachedImage(null)}
                        className="text-red-600 font-bold px-2 py-1"
                      >
                        ✕
                      </button>
                    </div>
                  )}

                  {/* Sample Prompt Chips */}
                  <div className="px-4 py-2 border-t border-gray-100 flex gap-2 overflow-x-auto text-[11px] bg-white">
                    {[
                      t('गेहूँ में पीला रतुआ का उपचार?', 'Yellow rust in wheat?'),
                      t('सोयाबीन में इल्ली की सर्वोत्तम दवा?', 'Caterpillar control in soybean?'),
                      t('सरसों में माहू (Aphid) रोकथाम?', 'Aphid control in mustard?'),
                      t('धान में ब्लास्ट रोग के लक्षण?', 'Blast symptoms in paddy?'),
                    ].map((chip, idx) => (
                      <button
                        key={idx}
                        onClick={() => {
                          setInputPrompt(chip);
                        }}
                        className="whitespace-nowrap px-2.5 py-1 rounded-full bg-gray-100 hover:bg-emerald-100 text-gray-700 hover:text-emerald-800 transition"
                      >
                        {chip}
                      </button>
                    ))}
                  </div>

                  {/* Chat Input Bar */}
                  <div className="p-3 border-t border-gray-200 bg-white flex items-center gap-2">
                    {/* Camera / Photo Upload Button */}
                    <label className="p-2 rounded-xl bg-gray-100 hover:bg-emerald-100 text-gray-600 hover:text-emerald-800 cursor-pointer transition">
                      <Camera className="w-5 h-5" />
                      <input
                        type="file"
                        accept="image/*"
                        className="hidden"
                        onChange={handleImageUpload}
                      />
                    </label>

                    {/* Hindi Voice Mic Button */}
                    <button
                      onClick={toggleSpeechRecognition}
                      className={`p-2 rounded-xl transition ${
                        isListening
                          ? 'bg-red-500 text-white animate-pulse'
                          : 'bg-gray-100 hover:bg-emerald-100 text-gray-600 hover:text-emerald-800'
                      }`}
                      title={isListening ? 'Listening...' : 'Tap to speak in Hindi/English'}
                    >
                      {isListening ? <MicOff className="w-5 h-5" /> : <Mic className="w-5 h-5" />}
                    </button>

                    {/* Text Input */}
                    <input
                      type="text"
                      value={inputPrompt}
                      onChange={(e) => setInputPrompt(e.target.value)}
                      onKeyDown={(e) => e.key === 'Enter' && handleSendMessage()}
                      placeholder={
                        isListening
                          ? t('सुन रहे हैं... बोलिए...', 'Listening... please speak...')
                          : t('सवाल लिखें या माइक दबाकर बोलें...', 'Type question or tap mic to speak...')
                      }
                      className="flex-1 bg-gray-50 border border-gray-300 rounded-xl px-3.5 py-2 text-xs md:text-sm focus:ring-2 focus:ring-emerald-500 focus:outline-none"
                    />

                    {/* Send Button */}
                    <button
                      onClick={handleSendMessage}
                      disabled={isAiTyping}
                      className="p-2.5 bg-[#1E7E34] hover:bg-[#155724] text-white rounded-xl shadow-xs transition disabled:opacity-50"
                    >
                      <Send className="w-4 h-4" />
                    </button>
                  </div>
                </div>
              )}

              {/* ================= TAB 5: FERTILIZER CALCULATOR ================= */}
              {activeTab === 'fertilizer' && (
                <div className="bg-white p-6 rounded-2xl border border-gray-200 shadow-sm space-y-5">
                  <div>
                    <h2 className="text-xl font-bold text-gray-900 flex items-center gap-2">
                      <FlaskConical className="w-5 h-5 text-[#1E7E34]" />
                      <span>{t('वैज्ञानिक खाद कैलकुलेटर (सटीक NPK गणना)', 'Scientific Fertilizer Dosage Calculator')}</span>
                    </h2>
                    <p className="text-xs text-gray-500">
                      {t('फसल व रकबे के अनुसार यूरिया, डीएपी व पोटाश की सटीक बोरियों की संख्या जानें।', 'Calculate exact commercial bags of Urea, DAP and MOP.')}
                    </p>
                  </div>

                  <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div>
                      <label className="block text-xs font-bold text-gray-700 mb-1">{t('फसल चुनें', 'Select Crop')}</label>
                      <select
                        value={fertCrop}
                        onChange={(e) => {
                          setFertCrop(e.target.value);
                          calculateFertilizers();
                        }}
                        className="w-full text-xs bg-gray-50 border border-gray-300 rounded-xl p-2.5"
                      >
                        {['Wheat (गेहूँ)', 'Paddy (धान)', 'Soybean (सोयाबीन)', 'Mustard (सरसों)', 'Cotton (कपास)', 'Potato (आलू)', 'Maize (मक्का)'].map((c) => (
                          <option key={c} value={c}>{c}</option>
                        ))}
                      </select>
                    </div>

                    <div>
                      <label className="block text-xs font-bold text-gray-700 mb-1">{t('खेत का क्षेत्रफल', 'Farm Area')}</label>
                      <input
                        type="number"
                        step="0.5"
                        value={fertArea}
                        onChange={(e) => {
                          setFertArea(e.target.value);
                          calculateFertilizers();
                        }}
                        className="w-full text-xs bg-gray-50 border border-gray-300 rounded-xl p-2.5"
                      />
                    </div>

                    <div>
                      <label className="block text-xs font-bold text-gray-700 mb-1">{t('इकाई', 'Unit')}</label>
                      <select
                        value={fertUnit}
                        onChange={(e) => {
                          setFertUnit(e.target.value);
                          calculateFertilizers();
                        }}
                        className="w-full text-xs bg-gray-50 border border-gray-300 rounded-xl p-2.5"
                      >
                        <option value="Acre">एकड़ (Acre)</option>
                        <option value="Bigha">बीघा (Bigha)</option>
                        <option value="Hectare">हेक्टेयर (Hectare)</option>
                      </select>
                    </div>
                  </div>

                  {/* Calculated Results Badges */}
                  <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 pt-3">
                    <div className="bg-blue-50 border border-blue-200 p-4 rounded-2xl">
                      <p className="text-xs font-bold text-blue-900">{t('यूरिया (Urea 46% N)', 'Urea (46% Nitrogen)')}</p>
                      <p className="text-3xl font-black text-blue-700 my-1">{fertUreaBags} {t('बोरी', 'Bags')}</p>
                      <p className="text-[11px] text-blue-600">(45 kg/बोरी)</p>
                    </div>

                    <div className="bg-emerald-50 border border-emerald-200 p-4 rounded-2xl">
                      <p className="text-xs font-bold text-emerald-900">{t('डी.ए.पी. (DAP 18:46:0)', 'DAP (18:46:0)')}</p>
                      <p className="text-3xl font-black text-emerald-700 my-1">{fertDapBags} {t('बोरी', 'Bags')}</p>
                      <p className="text-[11px] text-emerald-600">(50 kg/बोरी)</p>
                    </div>

                    <div className="bg-amber-50 border border-amber-200 p-4 rounded-2xl">
                      <p className="text-xs font-bold text-amber-900">{t('पोटाश (MOP 60% K)', 'MOP Potash (60% K)')}</p>
                      <p className="text-3xl font-black text-amber-700 my-1">{fertMopBags} {t('बोरी', 'Bags')}</p>
                      <p className="text-[11px] text-amber-600">(50 kg/बोरी)</p>
                    </div>
                  </div>

                  {/* Scientific Application Instructions */}
                  <div className="bg-gray-50 p-4 rounded-2xl border border-gray-200 text-xs text-gray-700 space-y-2">
                    <h4 className="font-bold text-[#1E7E34]">{t('वैज्ञानिक प्रयोग विधि:', 'Scientific Application Guide:')}</h4>
                    <p>• <strong>{t('बुवाई के समय (Basal Dose):', 'At Sowing (Basal):')}</strong> {t('संपूर्ण DAP, संपूर्ण MOP और यूरिया की एक-तिहाई मात्रा बुवाई के समय कतारों में बीज से 4-5 सेमी नीचे दें।', 'Apply 100% DAP, 100% MOP and 1/3rd Urea at sowing time.')}</p>
                    <p>• <strong>{t('प्रथम सिंचाई पर (First Irrigation):', 'At 1st Irrigation:')}</strong> {t('बुवाई के 21 दिन बाद पहली सिंचाई के तुरंत बाद यूरिया की दूसरी किश्त (1.5 बोरी) का बुरकाव करें।', 'Top dress second split of Urea after first irrigation.')}</p>
                    <p>• <strong>{t('कल्ले फूटने पर (Tillering):', 'At Tillering:')}</strong> {t('शेष यूरिया की तीसरी किश्त 45 दिन बाद दूसरी सिंचाई के समय दें।', 'Top dress remaining Urea at tillering stage.')}</p>
                  </div>
                </div>
              )}

              {/* ================= TAB 6: SOIL HEALTH ================= */}
              {activeTab === 'soil' && (
                <div className="bg-white p-6 rounded-2xl border border-gray-200 shadow-sm space-y-5">
                  <div>
                    <h2 className="text-xl font-bold text-gray-900 flex items-center gap-2">
                      <Calculator className="w-5 h-5 text-[#1E7E34]" />
                      <span>{t('मृदा स्वास्थ्य कार्ड एवं सुधार सलाह', 'Soil Health Card & Enhancement')}</span>
                    </h2>
                    <p className="text-xs text-gray-500">
                      {t('मिट्टी का प्रकार व जांच परिणाम दर्ज कर सुधार हेतु प्रमाणित सुझाव प्राप्त करें।', 'Enter soil test values for scientific soil conditioning.')}
                    </p>
                  </div>

                  <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div>
                      <label className="block text-xs font-bold text-gray-700 mb-1">{t('मिट्टी का प्रकार', 'Soil Type')}</label>
                      <select
                        value={soilType}
                        onChange={(e) => setSoilType(e.target.value)}
                        className="w-full text-xs bg-gray-50 border border-gray-300 rounded-xl p-2.5"
                      >
                        <option value="काली मिट्टी (Black Soil)">काली मिट्टी (Black Cotton Soil)</option>
                        <option value="जलोढ़ दोमट (Alluvial Loam)">जलोढ़ दोमट (Alluvial Soil)</option>
                        <option value="लाल-पीली (Red-Yellow Soil)">लाल-पीली मिट्टी (Red Soil)</option>
                        <option value="बलुई दोमट (Sandy Loam)">बलुई दोमट (Sandy Loam)</option>
                      </select>
                    </div>

                    <div>
                      <label className="block text-xs font-bold text-gray-700 mb-1">{t('pH मान (अम्लता/क्षारता)', 'Soil pH')}</label>
                      <input
                        type="number"
                        step="0.1"
                        value={soilPh}
                        onChange={(e) => setSoilPh(e.target.value)}
                        className="w-full text-xs bg-gray-50 border border-gray-300 rounded-xl p-2.5"
                      />
                    </div>

                    <div>
                      <label className="block text-xs font-bold text-gray-700 mb-1">{t('जैविक कार्बन (Organic Carbon %)', 'Organic Carbon %')}</label>
                      <input
                        type="number"
                        step="0.05"
                        value={soilOc}
                        onChange={(e) => setSoilOc(e.target.value)}
                        className="w-full text-xs bg-gray-50 border border-gray-300 rounded-xl p-2.5"
                      />
                    </div>
                  </div>

                  <div className="grid grid-cols-3 gap-3">
                    <div>
                      <label className="block text-xs font-bold text-gray-700 mb-1">N (kg/ha)</label>
                      <input
                        type="number"
                        value={soilNitrogen}
                        onChange={(e) => setSoilNitrogen(e.target.value)}
                        className="w-full text-xs bg-gray-50 border border-gray-300 rounded-xl p-2"
                      />
                    </div>
                    <div>
                      <label className="block text-xs font-bold text-gray-700 mb-1">P (kg/ha)</label>
                      <input
                        type="number"
                        value={soilPhosphorus}
                        onChange={(e) => setSoilPhosphorus(e.target.value)}
                        className="w-full text-xs bg-gray-50 border border-gray-300 rounded-xl p-2"
                      />
                    </div>
                    <div>
                      <label className="block text-xs font-bold text-gray-700 mb-1">K (kg/ha)</label>
                      <input
                        type="number"
                        value={soilPotash}
                        onChange={(e) => setSoilPotash(e.target.value)}
                        className="w-full text-xs bg-gray-50 border border-gray-300 rounded-xl p-2"
                      />
                    </div>
                  </div>

                  <div className="flex items-center gap-2">
                    <input
                      type="checkbox"
                      id="certifiedCheck"
                      checked={soilIsCertified}
                      onChange={(e) => setSoilIsCertified(e.target.checked)}
                      className="w-4 h-4 text-[#1E7E34] rounded"
                    />
                    <label htmlFor="certifiedCheck" className="text-xs text-gray-700">
                      {t('यह डेटा सरकारी सॉइल टेस्टिंग लैब (Soil Testing Lab) द्वारा प्रमाणित है', 'Data verified from Govt Soil Testing Laboratory card')}
                    </label>
                  </div>

                  <button
                    onClick={analyzeSoilHealth}
                    className="px-4 py-2 bg-[#1E7E34] hover:bg-[#155724] text-white text-xs font-bold rounded-xl shadow-xs"
                  >
                    {t('मृदा विश्लेषण व सुधार रिपोर्ट देखें', 'Analyze & Get Recommendations')}
                  </button>

                  {/* Recommendation Callout */}
                  <div className="bg-emerald-50 border border-emerald-200 p-4 rounded-2xl text-xs text-emerald-950 space-y-1">
                    <h4 className="font-bold text-sm text-[#1E7E34] flex items-center gap-1.5">
                      <CheckCircle2 className="w-4 h-4" />
                      <span>{t('वैज्ञानिक मृदा सुधार सिफारिशें:', 'Scientific Soil Advisory:')}</span>
                    </h4>
                    <p className="leading-relaxed mt-1">{soilAdvice}</p>
                  </div>
                </div>
              )}

              {/* ================= TAB 7: CROP CALENDAR ================= */}
              {activeTab === 'calendar' && (
                <div className="bg-white p-6 rounded-2xl border border-gray-200 shadow-sm space-y-5">
                  <div className="flex items-center justify-between">
                    <div>
                      <h2 className="text-xl font-bold text-gray-900 flex items-center gap-2">
                        <Calendar className="w-5 h-5 text-[#1E7E34]" />
                        <span>{t('फसल कैलेंडर व कार्य अनुसूची', 'Crop Calendar & Farm Operations')}</span>
                      </h2>
                      <p className="text-xs text-gray-500">
                        {t('बुवाई से कटाई तक प्रत्येक कार्य व सिंचाई का समयबद्ध प्रबंधन।', 'Sowing to harvest scheduled farm actions and reminders.')}
                      </p>
                    </div>
                  </div>

                  <div className="space-y-3">
                    {calendarEvents.map((ev) => (
                      <div
                        key={ev.id}
                        className={`p-4 rounded-2xl border flex items-start justify-between gap-3 transition ${
                          ev.isCompleted
                            ? 'bg-gray-50 border-gray-200 opacity-60'
                            : 'bg-white border-emerald-300 shadow-xs'
                        }`}
                      >
                        <div className="flex items-start gap-3">
                          <input
                            type="checkbox"
                            checked={ev.isCompleted}
                            onChange={() => {
                              setCalendarEvents((prev) =>
                                prev.map((item) =>
                                  item.id === ev.id ? { ...item, isCompleted: !item.isCompleted } : item
                                )
                              );
                            }}
                            className="w-5 h-5 text-[#1E7E34] mt-0.5 rounded cursor-pointer"
                          />
                          <div>
                            <span className="px-2 py-0.5 bg-emerald-100 text-[#1E7E34] text-[10px] font-bold rounded">
                              {ev.cropName}
                            </span>
                            <h4
                              className={`text-sm font-bold mt-1 ${
                                ev.isCompleted ? 'line-through text-gray-500' : 'text-gray-900'
                              }`}
                            >
                              {ev.activityType}
                            </h4>
                            <p className="text-xs text-gray-500 mt-0.5">{ev.notes}</p>
                          </div>
                        </div>
                        <span className="text-xs font-bold text-gray-700 bg-gray-100 px-3 py-1 rounded-lg">
                          {ev.dueDate}
                        </span>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* ================= TAB 8: PROFIT CALCULATOR ================= */}
              {activeTab === 'profit' && (
                <div className="bg-white p-6 rounded-2xl border border-gray-200 shadow-sm space-y-6">
                  <div>
                    <h2 className="text-xl font-bold text-gray-900 flex items-center gap-2">
                      <DollarSign className="w-5 h-5 text-[#1E7E34]" />
                      <span>{t('खेती मुनाफा कैलकुलेटर (Cost of Cultivation)', 'Farm Profit & Cost Calculator')}</span>
                    </h2>
                    <p className="text-xs text-gray-500">
                      {t('बीज, खाद, जुताई, सिंचाई व मजदूरी लागत घटाकर वास्तविक शुद्ध मुनाफे की गणना करें।', 'Compute net profit and per-acre return after all input expenses.')}
                    </p>
                  </div>

                  {/* Summary Banner */}
                  <div
                    className={`rounded-2xl p-5 text-white shadow-md ${
                      netProfit >= 0 ? 'bg-gradient-to-r from-[#155724] to-[#28A745]' : 'bg-red-700'
                    }`}
                  >
                    <p className="text-xs text-emerald-100 font-semibold uppercase tracking-wider">
                      {t('अनुमानित शुद्ध लाभ (Net Profit)', 'Estimated Net Profit')}
                    </p>
                    <h3 className="text-4xl font-black my-1">
                      ₹{Math.abs(netProfit).toLocaleString('en-IN')}
                    </h3>
                    <div className="grid grid-cols-3 gap-2 mt-4 pt-3 border-t border-white/20 text-xs">
                      <div>
                        <p className="text-emerald-200 text-[10px]">{t('कुल खर्च', 'Total Cost')}</p>
                        <p className="font-bold">₹{totalCost.toLocaleString('en-IN')}</p>
                      </div>
                      <div>
                        <p className="text-emerald-200 text-[10px]">{t('कुल बिक्री आय', 'Total Revenue')}</p>
                        <p className="font-bold">₹{totalRevenue.toLocaleString('en-IN')}</p>
                      </div>
                      <div>
                        <p className="text-emerald-200 text-[10px]">{t('प्रति एकड़ मुनाफा', 'Profit/Acre')}</p>
                        <p className="font-bold">₹{Math.round(profitPerAcre).toLocaleString('en-IN')}</p>
                      </div>
                    </div>
                  </div>

                  {/* Input Breakdowns */}
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div className="space-y-3 bg-gray-50 p-4 rounded-2xl border border-gray-200">
                      <h4 className="font-bold text-xs text-gray-800">{t('लागत विवरण (Expenses in ₹)', 'Cost Breakdown (₹)')}</h4>
                      <div className="grid grid-cols-2 gap-2 text-xs">
                        <div>
                          <label className="text-[11px] text-gray-600">{t('बीज खर्च', 'Seed')}</label>
                          <input
                            type="number"
                            value={costSeed}
                            onChange={(e) => setCostSeed(Number(e.target.value))}
                            className="w-full bg-white border border-gray-300 rounded-lg p-2"
                          />
                        </div>
                        <div>
                          <label className="text-[11px] text-gray-600">{t('खाद व उर्वरक', 'Fertilizers')}</label>
                          <input
                            type="number"
                            value={costFert}
                            onChange={(e) => setCostFert(Number(e.target.value))}
                            className="w-full bg-white border border-gray-300 rounded-lg p-2"
                          />
                        </div>
                        <div>
                          <label className="text-[11px] text-gray-600">{t('मजदूरी (लेबर)', 'Labour')}</label>
                          <input
                            type="number"
                            value={costLabour}
                            onChange={(e) => setCostLabour(Number(e.target.value))}
                            className="w-full bg-white border border-gray-300 rounded-lg p-2"
                          />
                        </div>
                        <div>
                          <label className="text-[11px] text-gray-600">{t('सिंचाई व बिजली', 'Irrigation')}</label>
                          <input
                            type="number"
                            value={costIrrigation}
                            onChange={(e) => setCostIrrigation(Number(e.target.value))}
                            className="w-full bg-white border border-gray-300 rounded-lg p-2"
                          />
                        </div>
                        <div>
                          <label className="text-[11px] text-gray-600">{t('ट्रैक्टर व यंत्र', 'Machinery')}</label>
                          <input
                            type="number"
                            value={costMachinery}
                            onChange={(e) => setCostMachinery(Number(e.target.value))}
                            className="w-full bg-white border border-gray-300 rounded-lg p-2"
                          />
                        </div>
                        <div>
                          <label className="text-[11px] text-gray-600">{t('दवा व अन्य फुटकर', 'Pesticide & Other')}</label>
                          <input
                            type="number"
                            value={costOther}
                            onChange={(e) => setCostOther(Number(e.target.value))}
                            className="w-full bg-white border border-gray-300 rounded-lg p-2"
                          />
                        </div>
                      </div>
                    </div>

                    <div className="space-y-3 bg-emerald-50/50 p-4 rounded-2xl border border-emerald-200">
                      <h4 className="font-bold text-xs text-emerald-950">{t('उत्पादन व मंडी भाव', 'Yield & Mandi Price')}</h4>
                      <div className="space-y-2 text-xs">
                        <div>
                          <label className="text-[11px] text-gray-600">{t('खेत का रकबा (एकड़)', 'Land Area (Acres)')}</label>
                          <input
                            type="number"
                            value={profitArea}
                            onChange={(e) => setProfitArea(Number(e.target.value))}
                            className="w-full bg-white border border-gray-300 rounded-lg p-2"
                          />
                        </div>
                        <div>
                          <label className="text-[11px] text-gray-600">{t('कुल अपेक्षित उत्पादन (क्विंटल)', 'Expected Yield (Quintals)')}</label>
                          <input
                            type="number"
                            value={yieldQuintals}
                            onChange={(e) => setYieldQuintals(Number(e.target.value))}
                            className="w-full bg-white border border-gray-300 rounded-lg p-2"
                          />
                        </div>
                        <div>
                          <label className="text-[11px] text-gray-600">{t('अपेक्षित मंडी विक्रय भाव (₹/क्विंटल)', 'Selling Price (₹/Quintal)')}</label>
                          <input
                            type="number"
                            value={salePrice}
                            onChange={(e) => setSalePrice(Number(e.target.value))}
                            className="w-full bg-white border border-gray-300 rounded-lg p-2"
                          />
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              )}

              {/* ================= TAB 9: GOVERNMENT SCHEMES ================= */}
              {activeTab === 'schemes' && (
                <div className="space-y-4">
                  <div>
                    <h2 className="text-xl font-bold text-gray-900 flex items-center gap-2">
                      <Landmark className="w-5 h-5 text-[#1E7E34]" />
                      <span>{t('सत्यापित सरकारी कृषि योजनाएं', 'Verified Government Agricultural Schemes')}</span>
                    </h2>
                    <p className="text-xs text-gray-500">
                      {t('पीएम-किसान, फसल बीमा, सोलर पंप अनुदान, केसीसी व यंत्र सब्सिडी की संपूर्ण जानकारी।', 'Official benefits, eligibility and direct government links.')}
                    </p>
                  </div>

                  <div className="space-y-4">
                    {[
                      {
                        name: 'प्रधानमंत्री किसान सम्मान निधि (PM-KISAN)',
                        benefit: 'सभी पात्र किसान परिवारों को प्रति वर्ष ₹6,000 की वित्तीय सहायता (3 किश्तों में ₹2,000 सीधे बैंक खाते में)।',
                        eligibility: 'कृषि योग्य भूमि वाले सभी भूमिधारक किसान परिवार (संस्थागत भूमिधारक व आयकर दाता अपात्र)।',
                        docs: 'आधार कार्ड, बैंक पासबुक, भू-अभिलेख (खसरा-खतौनी), आधार लिंक मोबाइल।',
                        link: 'https://pmkisan.gov.in',
                      },
                      {
                        name: 'प्रधानमंत्री फसल बीमा योजना (PMFBY)',
                        benefit: 'प्राकृतिक आपदाओं, सूखा, ओलावृष्टि, कीट-रोग से फसल नुकसान पर न्यूनतम प्रीमियम (रबी 1.5%, खरीफ 2%) पर पूर्ण क्लेम।',
                        eligibility: 'अधिसूचित क्षेत्रों में अधिसूचित फसल उगाने वाले बटाईदार व काश्तकार सहित सभी किसान।',
                        docs: 'बुवाई प्रमाण पत्र, पटवारी रिपोर्ट, खसरा नकल, बैंक पासबुक, आधार।',
                        link: 'https://pmfby.gov.in',
                      },
                      {
                        name: 'किसान क्रेडिट कार्ड (KCC Scheme)',
                        benefit: 'समय पर भुगतान पर 4% की अत्यंत रियायती ब्याज दर पर ₹3 लाख तक का कृषि ऋण बिना गारंटी।',
                        eligibility: 'सभी किसान, काश्तकार, मौखिक पट्टेदार, पशुपालक एवं मत्स्यपालक।',
                        docs: 'पहचान पत्र, निवास प्रमाण, भूमि स्वामित्व दस्तावेज, पासपोर्ट फोटो।',
                        link: 'https://www.myscheme.gov.in/schemes/kcc',
                      },
                      {
                        name: 'पीएम कुसुम सोलर पंप योजना (PM-KUSUM)',
                        benefit: 'खेतों में सिंचाई हेतु 3 से 10 HP सोलर पंप स्थापना पर केंद्र व राज्य सरकार द्वारा 60% तक भारी अनुदान।',
                        eligibility: 'व्यक्तिगत किसान, कृषक उत्पादक संगठन (FPO), जल उपभोक्ता संघ।',
                        docs: 'आधार, बैंक पासबुक, खेत का खसरा, जल स्रोत उपलब्धता प्रमाण।',
                        link: 'https://pmkusum.mnre.gov.in',
                      },
                      {
                        name: 'कृषि यंत्रीकरण उप-मिशन (SMAM Subsidy)',
                        benefit: 'ट्रैक्टर, रोटावेटर, रीपर, ड्रोन, लेजर लेवलर की खरीद पर 40% से 50% तक सरकारी सब्सिडी।',
                        eligibility: 'लघु एवं सीमांत किसान, महिला कृषक, अनुसूचित जाति/जनजाति कृषक।',
                        docs: 'आधार, जाति प्रमाण पत्र (यदि लागू हो), खसरा-खतौनी, बैंक पासबुक।',
                        link: 'https://agrimachinery.nic.in',
                      },
                    ].map((scheme, i) => (
                      <div key={i} className="bg-white p-5 rounded-2xl border border-gray-200 shadow-sm space-y-2">
                        <div className="flex items-start justify-between">
                          <h3 className="font-bold text-base text-gray-900">{scheme.name}</h3>
                          <a
                            href={scheme.link}
                            target="_blank"
                            rel="noreferrer"
                            className="inline-flex items-center gap-1 text-xs font-bold text-[#1E7E34] hover:underline bg-emerald-50 px-2.5 py-1 rounded-lg"
                          >
                            <span>{t('आधिकारिक पोर्टल', 'Official Portal')}</span>
                            <ExternalLink className="w-3.5 h-3.5" />
                          </a>
                        </div>
                        <p className="text-xs text-gray-700">
                          <strong>{t('लाभ:', 'Benefit:')}</strong> {scheme.benefit}
                        </p>
                        <p className="text-xs text-gray-600">
                          <strong>{t('पात्रता:', 'Eligibility:')}</strong> {scheme.eligibility}
                        </p>
                        <p className="text-[11px] text-gray-500">
                          <strong>{t('आवश्यक दस्तावेज:', 'Required Docs:')}</strong> {scheme.docs}
                        </p>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* ================= TAB 10: MACHINERY RENTAL ================= */}
              {activeTab === 'machinery' && (
                <div className="space-y-4">
                  <div className="flex items-center justify-between">
                    <div>
                      <h2 className="text-xl font-bold text-gray-900 flex items-center gap-2">
                        <Tractor className="w-5 h-5 text-[#1E7E34]" />
                        <span>{t('कृषि यंत्र एवं ट्रैक्टर किराया सेवा', 'Farm Machinery Rental Hub')}</span>
                      </h2>
                      <p className="text-xs text-gray-500">
                        {t('ट्रैक्टर, कंबाइन हार्वेस्टर, रोटावेटर व कृषि ड्रोन किफायती दरों पर बुक करें।', 'Rent tractors, harvesters and drones locally.')}
                      </p>
                    </div>
                  </div>

                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    {[
                      {
                        title: 'महिंद्रा 575 DI (45 HP) रोटावेटर सहित',
                        owner: 'बलविंदर सिंह',
                        phone: '+91 98140 11223',
                        loc: 'लुधियाना, पंजाब (खन्ना क्षेत्र)',
                        rateHour: 600,
                        rateAcre: 950,
                        status: 'उपलब्ध (Available)',
                      },
                      {
                        title: 'प्रीत 987 कंबाइन हार्वेस्टर (धान व गेहूँ)',
                        owner: 'दिलीप पाटीदार',
                        phone: '+91 94250 88776',
                        loc: 'देवास, मध्य प्रदेश',
                        rateHour: 1800,
                        rateAcre: 1600,
                        status: 'उपलब्ध (Available)',
                      },
                      {
                        title: 'कृषि स्प्रे ड्रोन (10 लीटर यूरिया/कीटनाशक छिड़काव)',
                        owner: 'अमित कुमार (एग्री-टेक किसान)',
                        phone: '+91 98710 33445',
                        loc: 'करनाल, हरियाणा',
                        rateHour: 900,
                        rateAcre: 450,
                        status: 'उपलब्ध (Available)',
                      },
                      {
                        title: 'लेजर लैंड लेवलर (सटीक समतलीकरण)',
                        owner: 'सुरेश चौधरी',
                        phone: '+91 97840 55667',
                        loc: 'कोटा, राजस्थान',
                        rateHour: 800,
                        rateAcre: 1100,
                        status: 'व्यस्त (Booked)',
                      },
                    ].map((mach, i) => (
                      <div key={i} className="bg-white p-4 rounded-2xl border border-gray-200 shadow-sm flex flex-col justify-between">
                        <div>
                          <div className="flex justify-between items-start">
                            <h3 className="font-bold text-sm text-gray-900">{mach.title}</h3>
                            <span className="px-2 py-0.5 text-[10px] bg-green-100 text-green-800 rounded font-semibold">
                              {mach.status}
                            </span>
                          </div>
                          <p className="text-xs text-gray-600 mt-1">📍 {mach.loc}</p>
                          <p className="text-xs text-gray-500">👤 {mach.owner} ({mach.phone})</p>
                        </div>
                        <div className="mt-3 pt-3 border-t border-gray-100 flex items-center justify-between">
                          <div>
                            <span className="text-sm font-bold text-[#1E7E34]">₹{mach.rateAcre}/एकड़</span>
                            <span className="text-[11px] text-gray-400 ml-1.5">(₹{mach.rateHour}/घंटा)</span>
                          </div>
                          <button
                            onClick={() => alert(`मालिक ${mach.owner} (${mach.phone}) से बात करें।`)}
                            className="px-3 py-1.5 bg-[#1E7E34] text-white text-xs font-bold rounded-lg hover:bg-[#155724] flex items-center gap-1"
                          >
                            <Phone className="w-3.5 h-3.5" />
                            <span>{t('कॉल करें', 'Call')}</span>
                          </button>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* ================= TAB 11: CROP MARKETPLACE ================= */}
              {activeTab === 'marketplace' && (
                <div className="space-y-4">
                  <div className="flex items-center justify-between">
                    <div>
                      <h2 className="text-xl font-bold text-gray-900 flex items-center gap-2">
                        <Store className="w-5 h-5 text-[#1E7E34]" />
                        <span>{t('किसान फसल बाज़ार (Direct Farmer-to-Buyer)', 'Crop Marketplace')}</span>
                      </h2>
                      <p className="text-xs text-gray-500">
                        {t('सीधे किसानों से फसल खरीदें या अपनी उपज बिक्री हेतु लिस्ट करें।', 'Buy or sell crops directly without middlemen.')}
                      </p>
                    </div>
                  </div>

                  <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                    {[
                      {
                        crop: 'लोकवन शरबती गेहूँ (Lokwan Wheat)',
                        qty: '85 क्विंटल',
                        price: '₹2,850/क्विंटल',
                        farmer: 'कैलाश पटेल',
                        phone: '+91 94251 77665',
                        loc: 'सीहोर, मध्य प्रदेश',
                      },
                      {
                        crop: 'पीला सोयाबीन (JS 9560 Soybean)',
                        qty: '120 क्विंटल',
                        price: '₹4,650/क्विंटल',
                        farmer: 'सुखविंदर चीमा',
                        phone: '+91 98150 44332',
                        loc: 'कोटा, राजस्थान',
                      },
                      {
                        crop: 'काली सरसों (Black Mustard)',
                        qty: '45 क्विंटल',
                        price: '₹5,500/क्विंटल',
                        farmer: 'रामगोपाल यादव',
                        phone: '+91 97531 22446',
                        loc: 'मथुरा, उत्तर प्रदेश',
                      },
                    ].map((item, i) => (
                      <div key={i} className="bg-white p-4 rounded-2xl border border-gray-200 shadow-sm flex flex-col justify-between">
                        <div>
                          <span className="text-[10px] font-bold bg-amber-100 text-amber-900 px-2 py-0.5 rounded">
                            {t('सत्यापित किसान उपज', 'Farmer Listing')}
                          </span>
                          <h3 className="font-bold text-sm text-gray-900 mt-2">{item.crop}</h3>
                          <p className="text-xs text-gray-600 mt-0.5">उपलब्ध: {item.qty}</p>
                          <p className="text-xs text-gray-500">📍 {item.loc}</p>
                        </div>
                        <div className="mt-3 pt-3 border-t border-gray-100 flex items-center justify-between">
                          <span className="font-black text-[#1E7E34] text-sm">{item.price}</span>
                          <button
                            onClick={() => alert(`किसान ${item.farmer} (${item.phone}) को कॉल करें`)}
                            className="px-3 py-1.5 bg-[#1E7E34] text-white text-xs font-bold rounded-lg hover:bg-[#155724] flex items-center gap-1"
                          >
                            <Phone className="w-3.5 h-3.5" />
                            <span>{t('सम्पर्क', 'Contact')}</span>
                          </button>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* ================= TAB 12: KISAN COMMUNITY ================= */}
              {activeTab === 'community' && (
                <div className="space-y-4">
                  <div>
                    <h2 className="text-xl font-bold text-gray-900 flex items-center gap-2">
                      <Users className="w-5 h-5 text-[#1E7E34]" />
                      <span>{t('किसान चौपाल (Community Forum)', 'Kisan Community Forum')}</span>
                    </h2>
                    <p className="text-xs text-gray-500">
                      {t('अन्य किसान भाइयों के साथ अनुभव साझा करें, सवाल पूछें और सलाह पाएं।', 'Peer farmer discussions and practical farming knowledge.')}
                    </p>
                  </div>

                  <div className="space-y-4">
                    {[
                      {
                        author: 'जगदीश सिंह',
                        loc: 'पटियाला, पंजाब',
                        title: 'गेहूँ की बुवाई में सुपर सीडर तकनीक का अनुभव',
                        content: 'किसान भाइयों, इस बार मैंने पराली जलाए बिना सीधे सुपर सीडर से गेहूँ की बिजाई की। जमाव 95% से अधिक रहा है और खाद की बचत भी हुई है। किसी भाई को कोई सवाल हो तो जरूर पूछें।',
                        likes: 24,
                        comments: 5,
                      },
                      {
                        author: 'विकास पाटीदार',
                        loc: 'उज्जैन, मध्य प्रदेश',
                        title: 'चने में उकठा (Wilt) रोग से बचाव के घरेलू व जैविक उपाय',
                        content: 'चने की बुवाई से पहले बीजोपचार ट्राइकोडर्मा विरिडी (Trichoderma viride) 10 ग्राम प्रति कि.ग्रा. से किया था। अब तक खेत में उकठा का प्रकोप बिल्कुल शून्य है। जैविक खेती अपनाएं।',
                        likes: 42,
                        comments: 8,
                      },
                    ].map((post, i) => (
                      <div key={i} className="bg-white p-5 rounded-2xl border border-gray-200 shadow-sm space-y-3">
                        <div className="flex items-center gap-2.5">
                          <div className="w-9 h-9 rounded-full bg-emerald-100 text-[#1E7E34] font-bold flex items-center justify-center text-xs">
                            {post.author[0]}
                          </div>
                          <div>
                            <p className="text-xs font-bold text-gray-900">{post.author}</p>
                            <p className="text-[10px] text-gray-500">📍 {post.loc}</p>
                          </div>
                        </div>
                        <h3 className="font-bold text-sm text-gray-900">{post.title}</h3>
                        <p className="text-xs text-gray-700 leading-relaxed">{post.content}</p>
                        <div className="flex items-center gap-4 text-xs text-gray-500 pt-2 border-t border-gray-100">
                          <button className="flex items-center gap-1 text-[#1E7E34] font-bold">
                            <span>👍 {post.likes}</span>
                          </button>
                          <span>💬 {post.comments} {t('टिप्पणियां', 'Comments')}</span>
                          <button className="ml-auto text-gray-400 hover:text-gray-600">
                            <Share2 className="w-4 h-4" />
                          </button>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* ================= TAB 13: FARM DIARY ================= */}
              {activeTab === 'diary' && (
                <div className="bg-white p-6 rounded-2xl border border-gray-200 shadow-sm space-y-5">
                  <div className="flex items-center justify-between">
                    <div>
                      <h2 className="text-xl font-bold text-gray-900 flex items-center gap-2">
                        <BookOpen className="w-5 h-5 text-[#1E7E34]" />
                        <span>{t('कृषि दैनिकी / बहीखाता (Farm Diary)', 'Farm Diary & Ledger')}</span>
                      </h2>
                      <p className="text-xs text-gray-500">
                        {t('खेत के दैनिक कार्य, खर्च, दवाई छिड़काव व गहाई का बहीखाता।', 'Record daily operations, input expenses and harvest logs.')}
                      </p>
                    </div>
                  </div>

                  <div className="space-y-3">
                    {diaryEntries.map((entry) => (
                      <div
                        key={entry.id}
                        className="p-4 rounded-2xl bg-gray-50 border border-gray-200 flex items-center justify-between"
                      >
                        <div>
                          <div className="flex items-center gap-2">
                            <span className="px-2 py-0.5 bg-emerald-100 text-[#1E7E34] text-[10px] font-bold rounded">
                              {entry.crop}
                            </span>
                            <span className="text-[11px] text-gray-400">{entry.date}</span>
                          </div>
                          <h4 className="font-bold text-xs text-gray-800 mt-1">{entry.activity}</h4>
                          <p className="text-[11px] text-gray-500">{entry.notes}</p>
                        </div>
                        <div className="text-right">
                          <p className="text-xs text-gray-400">{t('खर्च', 'Expense')}</p>
                          <p className="text-base font-black text-rose-600">₹{entry.expense.toLocaleString('en-IN')}</p>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* ================= TAB 14: FARMER PROFILE ================= */}
              {activeTab === 'profile' && (
                <div className="bg-white p-6 rounded-2xl border border-gray-200 shadow-sm space-y-5 max-w-2xl">
                  <div>
                    <h2 className="text-xl font-bold text-gray-900 flex items-center gap-2">
                      <User className="w-5 h-5 text-[#1E7E34]" />
                      <span>{t('किसान प्रोफ़ाइल व खाता (Profile)', 'Farmer Profile & Farm Info')}</span>
                    </h2>
                    <p className="text-xs text-gray-500">
                      {t('अपनी व्यक्तिगत व कृषि भूमि की जानकारी सुरक्षित रखें।', 'Manage personal details and farm records.')}
                    </p>
                  </div>

                  <div className="space-y-3 text-xs">
                    <div>
                      <label className="block font-bold text-gray-700 mb-1">{t('किसान का नाम', 'Farmer Name')}</label>
                      <input
                        type="text"
                        value={farmerName}
                        onChange={(e) => setFarmerName(e.target.value)}
                        className="w-full bg-gray-50 border border-gray-300 rounded-xl p-2.5"
                      />
                    </div>
                    <div>
                      <label className="block font-bold text-gray-700 mb-1">{t('मोबाइल नंबर', 'Mobile Number')}</label>
                      <input
                        type="text"
                        value={farmerPhone}
                        onChange={(e) => setFarmerPhone(e.target.value)}
                        className="w-full bg-gray-50 border border-gray-300 rounded-xl p-2.5"
                      />
                    </div>
                    <div className="grid grid-cols-2 gap-3">
                      <div>
                        <label className="block font-bold text-gray-700 mb-1">{t('राज्य', 'State')}</label>
                        <input
                          type="text"
                          value={farmerState}
                          onChange={(e) => setFarmerState(e.target.value)}
                          className="w-full bg-gray-50 border border-gray-300 rounded-xl p-2.5"
                        />
                      </div>
                      <div>
                        <label className="block font-bold text-gray-700 mb-1">{t('जिला', 'District')}</label>
                        <input
                          type="text"
                          value={farmerDistrict}
                          onChange={(e) => setFarmerDistrict(e.target.value)}
                          className="w-full bg-gray-50 border border-gray-300 rounded-xl p-2.5"
                        />
                      </div>
                    </div>
                    <div>
                      <label className="block font-bold text-gray-700 mb-1">{t('कुल कृषि भूमि (रकबा)', 'Total Farm Land')}</label>
                      <input
                        type="text"
                        value={farmerLand}
                        onChange={(e) => setFarmerLand(e.target.value)}
                        className="w-full bg-gray-50 border border-gray-300 rounded-xl p-2.5"
                      />
                    </div>

                    <button
                      onClick={() => alert('किसान प्रोफ़ाइल सफलतापूर्वक सहेज ली गई है!')}
                      className="mt-2 px-5 py-2.5 bg-[#1E7E34] text-white font-bold rounded-xl shadow-xs hover:bg-[#155724]"
                    >
                      {t('प्रोफ़ाइल सहेजें', 'Save Profile')}
                    </button>
                  </div>
                </div>
              )}
            </div>
          </div>

          {/* Mobile Bottom Navigation Bar (Visible on mobile screens or in Phone Preview Frame) */}
          <div className="md:hidden bg-white border-t border-gray-200 px-2 py-1.5 flex justify-around items-center select-none shrink-0 shadow-lg">
            {[
              { id: 'home', icon: Sprout, label: t('होम', 'Home') },
              { id: 'mandi', icon: TrendingUp, label: t('मंडी', 'Mandi') },
              { id: 'weather', icon: CloudSun, label: t('मौसम', 'Weather') },
              { id: 'ai', icon: Bot, label: t('एआई', 'AI') },
              { id: 'fertilizer', icon: FlaskConical, label: t('खाद', 'Fertilizer') },
            ].map((tab) => {
              const Icon = tab.icon;
              const isActive = activeTab === tab.id;
              return (
                <button
                  key={tab.id}
                  onClick={() => setActiveTab(tab.id)}
                  className={`flex flex-col items-center py-1 px-2 rounded-xl transition ${
                    isActive ? 'text-[#1E7E34] font-bold' : 'text-gray-400 hover:text-gray-600'
                  }`}
                >
                  <Icon className="w-5 h-5" />
                  <span className="text-[10px] mt-0.5">{tab.label}</span>
                </button>
              );
            })}
          </div>
        </div>
      </main>

      {/* --- FOOTER --- */}
      <footer className="bg-white border-t border-gray-200 py-3 text-center text-xs text-gray-500">
        <div className="max-w-7xl mx-auto px-4 flex flex-col sm:flex-row items-center justify-between gap-2">
          <p>© 2026 Mandi Mitra AI (मंडी मित्र एआई) • {t('भारतीय किसानों का सच्चा साथी', 'Empowering Indian Farmers')}</p>
          <div className="flex items-center gap-3">
            <a href="/api/download-flutter-zip" className="text-[#1E7E34] font-bold hover:underline flex items-center gap-1">
              <Download className="w-3.5 h-3.5" />
              <span>Download Flutter Code (.ZIP)</span>
            </a>
            <span>•</span>
            <button onClick={() => setShowCodeInspector(true)} className="text-[#1E7E34] font-semibold hover:underline">
              Inspect Dart Files
            </button>
          </div>
        </div>
      </footer>
    </div>
  );
}
