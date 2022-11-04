import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medi_track/components/add_textfield.dart';
import 'package:medi_track/components/medicine_type.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../api/notification_api.dart';
import '../components/info_container.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String userid = auth.currentUser!.uid;
  late String dropdownvalue = AppLocalizations.of(context)!.weekly;
  late var items = [
    AppLocalizations.of(context)!.daily,
    AppLocalizations.of(context)!.weekly,
    AppLocalizations.of(context)!.monthly,
  ];
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String image = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController dosageController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  TimeOfDay time = TimeOfDay(hour: 0, minute: 0);
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: time);
    if (picked != null && picked != time) {
      setState(() {
        time = picked;
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool start) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (start == true) {
      if (picked != null && picked != startDate)
        setState(() {
          startDate = picked;
        });
    } else {
      if (picked != null && picked != endDate)
        setState(() {
          endDate = picked;
        });
    }
  }

  double space = 40;
  List<String> med=['aaacholin', 'aaacholine', 'abacavir', 'abacavirlamivudinmepha', 'abasaglar', 'abecma', 'abilify', 'abirateron', 'abiraterone', 'abirateronteva', 'abiratrone', 'abraxane', 'abrilada', 'absinthium', 'acarizax', 'acc', 'accofil', 'accupaque', 'accupro', 'accuretic', 'acetalgin', 'acetocaustin', 'acetylcystein', 'acetylfelan', 'achillea', 'aciclovir', 'acicutan', 'acide', 'acido', 'acidox', 'acidum', 'acimethin', 'aclasta', 'acn', 'acnatac', 'acne', 'actalgine', 'actate', 'actemra', 'actikerall', 'actilyse', 'actiq', 'activelle', 'activital', 'actocaustine', 'actonel', 'actos', 'acular', 'acyclovir', 'acyclovirmepha', 'adartrel', 'adcetris', 'adcirca', 'addaven', 'adempas', 'adenuric', 'adler', 'adrenalin', 'adreview', 'adriblastin', 'adrnaline', 'adtralza', 'advagraf', 'advantan', 'advate', 'adynovi', 'aequifusine', 'aerius', 'aesculaforce', 'aesculamed', 'aethoxysklerol', 'aethylchlorid', 'afinitor', 'afribin', 'afstyla', 'aggrastat', 'agiolax', 'agomelatin', 'agomelatina', 'agomelatine', 'agomelatinmepha', 'agomlatine', 'agopton', 'aimovig', 'airol', 'ajovy', 'akineton', 'aklief', 'aknemycin', 'aknichthol', 'aknilox', 'aktiferrin', 'akutur', 'akynzeo', 'alacare', 'albicansan', 'albumin', 'albunorm', 'alcac', 'alcacyl', 'alcaine', 'aldactone', 'aldara', 'aldomet', 'alecensa', 'alendron', 'alendronat', 'alendronate', 'alendronato', 'alendronmepha', 'aleve', 'alfuzosin', 'alfuzosina', 'alfuzosine', 'alfuzosinmepha', 'algesx', 'algifor', 'algiforl', 'alimta', 'alkaseltzer', 'alkeran', 'alkindi', 'allergocomod', 'allergodil', 'allergodilallergodil', 'allergovit', 'allergox', 'allopur', 'allopurinol', 'allopurinolmepha', 'allsan', 'alluzience', 'allvita', 'almogran', 'alofisel', 'alopexy', 'aloxi', 'alpenaflor', 'alphacain', 'alphacane', 'alphagan', 'alpicortf', 'alpinamed', 'alprolix', 'alucol', 'alunbrig', 'alustal', 'alutard', 'alvesco', 'amaphyto', 'amaryl', 'amavita', 'ambiful', 'ambisome', 'ambrisentan', 'ambrisentanmepha', 'ameluz', 'amgevita', 'amikin', 'aminomix', 'aminophyllin', 'aminoplasmal', 'aminoven', 'amiodar', 'amiodaron', 'amiodarone', 'amiodaronmepha', 'amisulpride', 'amisulpridmepha', 'amlodipin', 'amlodipina', 'amlodipinacino', 'amlodipincimex', 'amlodipine', 'amlodipineacino', 'amlodipinmepha', 'amlodipinvalsartan', 'amlodipinvalsartanhctmepha', 'amlodipinvalsartanmepha', 'amorolfin', 'amorolfine', 'amorolfinmepha', 'amoxicillin', 'amoxicillina', 'amoxicilline', 'amoxidin', 'amoximepha', 'amphomoronal', 'ampres', 'amsidyl', 'amukina', 'amukinamed', 'anaemodoron', 'anafranil', 'anagrelid', 'anastrozol', 'anastrozole', 'anastrozolo', 'anastrozolteva', 'ancopir', 'ancotil', 'andreafol', 'andreafolcompresse', 'andreafolcomprims', 'andreafoltabletten', 'andreamag', 'andreavit', 'androcur', 'andropecia', 'andursil', 'anesderm', 'anexate', 'angeliq', 'angiben', 'angina', 'anginazol', 'anginova', 'angisan', 'angisilx', 'angocin', 'angusta', 'anidulafungin', 'anoro', 'anouk', 'antabus', 'antidry', 'antihydral', 'antistax', 'antramups', 'anxiolit', 'aphenylbarbit', 'aphnylbarbite', 'apidra', 'apligraf', 'aplona', 'apodolor', 'apoenterit', 'apogo', 'apohepat', 'apoinfekt', 'apomorfina', 'apomorphin', 'apomorphine', 'apostom', 'apotheke', 'apotuss', 'apranax', 'aprokam', 'aprovel', 'aptivus', 'apydan', 'aqua', 'aranesp', 'arava', 'arbid', 'arcoxia', 'argatra', 'argile', 'argilla', 'aricept', 'ariceptevess', 'arilin', 'arimidex', 'aripiprazol', 'aripiprazole', 'aripiprazolmepha', 'aripiprazolo', 'arixtra', 'arkocaps', 'arlevert', 'arnigel', 'arnuity', 'aromasin', 'arteoptic', 'arteriavita', 'arthrotec', 'artirem', 'artiss', 'aruna', 'asacol', 'asatabs', 'ascosal', 'aspgic', 'aspirin', 'aspirina', 'aspirinac', 'aspirinc', 'aspirine', 'aspirinec', 'aspro', 'ass', 'assan', 'atacand', 'atarax', 'atazanavirmepha', 'atdurex', 'atectura', 'atedurex', 'atenativ', 'atenil', 'atenololmepha', 'atnil', 'atomoxetin', 'atomoxetinmepha', 'atorva', 'atorvastatin', 'atorvastatina', 'atorvastatine', 'atorvastatinmepha', 'atorvastax', 'atosiban', 'atovaquon', 'atovaquone', 'atovaquonproguanilmepha', 'atovaquonproguanilmephaatovaquonproguanilmepha', 'atozet', 'atracurium', 'atriance', 'atripla', 'atromed', 'atropair', 'atropin', 'atropina', 'atropine', 'atropinsulfat', 'atropinum', 'atrovent', 'attentin', 'aubagio', 'augentonicum', 'augmentin', 'aulin', 'aurorix', 'avalox', 'avamys', 'avastin', 'avenaforce', 'aviral', 'avodart', 'avogel', 'avonex', 'avonexavonex', 'axotide', 'axulta', 'axura', 'azacitidin', 'azacitidina', 'azacitidine', 'azactam', 'azafalk', 'azalia', 'azarek', 'azarga', 'aziclav', 'azilect', 'azithromycin', 'azithromycine', 'azithromycinmepha', 'azitromicina', 'azopt', 'azoto', 'azzalure', 'baclocalm', 'baclofen', 'bactiflox', 'bactrim', 'bactroban', 'badesalz', 'bain', 'balance', 'baldriparan', 'balmed', 'balsamo', 'baqsimi', 'baraclude', 'baume', 'bavencio', 'becetamol', 'beclo', 'becozym', 'becozyme', 'bedranol', 'begrocit', 'bekunis', 'belara', 'belarina', 'beloc', 'benadon', 'bendamustin', 'bendamustine', 'benefix', 'benepali', 'benepalitm', 'benerva', 'benexol', 'benlysta', 'benocten', 'benuron', 'benylin', 'benzac', 'benzocaine', 'beovu', 'bepanthen', 'beriate', 'berinert', 'beriplex', 'berirab', 'berocca', 'berodual', 'beromun', 'besponsa', 'besremi', 'betadina', 'betadine', 'betaferon', 'betahistin', 'betahistinmepha', 'betaseptic', 'betaserc', 'betesil', 'betmiga', 'betnesol', 'betnovate', 'betnovatec', 'betoptic', 'bevacizumabteva', 'bexin', 'bexine', 'bexsero', 'biafine', 'bicalutamid', 'bicalutamide', 'bicalutamidteva', 'bicarbonate', 'bicarbonato', 'bicavera', 'bicnu', 'biktarvy', 'bilaxten', 'bilifuge', 'bilol', 'bimatoprost', 'bimatoprostmepha', 'binocrit', 'binosto', 'biodoron', 'bioflorin', 'biohtin', 'biostimol', 'biotin', 'biotina', 'biotinarausch', 'biotinbiomed', 'biotine', 'biotinebiomed', 'biotinerausch', 'biotinmerz', 'biotinrausch', 'biovigor', 'biphozyl', 'bisacofelan', 'bisolvon', 'bisoprolol', 'bisoprololhctmepha', 'bisoprololmepha', 'bisoprololo', 'bitex', 'bitumol', 'blasosan', 'blattgrn', 'blenrep', 'bleomycin', 'bleu', 'blincyto', 'blissel', 'blomycine', 'blopress', 'bocouture', 'boldocynara', 'boldosan', 'bondronat', 'bonox', 'bonviva', 'boostrix', 'bortezomib', 'bortzomib', 'bosentanmepha', 'bosulif', 'botox', 'bovisan', 'braftovi', 'bramitob', 'braunoderm', 'braunol', 'braunovidon', 'brevibloc', 'breyanzi', 'bricanyl', 'bridion', 'brilique', 'brimonidinmepha', 'brimovision', 'brinavess', 'brintellix', 'brivex', 'briviact', 'bronchalisheel', 'bronchialpastillen', 'bronchipret', 'bronchosan', 'bronchostop', 'bronchostopduo', 'bronchovaxom', 'brufen', 'brukinsa', 'btahistine', 'buccalin', 'buccaline', 'bucco', 'buccolam', 'budenid', 'budenofalk', 'budesonid', 'budsonide', 'bulbod', 'bulboid', 'bupivacain', 'bupivacane', 'buprenorphinmepha', 'burgerstein', 'buscopan', 'busilvex', 'buvidal', 'bydureon', 'byetta', 'byooviz', 'cabaser', 'cabazitaxel', 'cablivi', 'cabometyx', 'caduet', 'caelyx', 'caladryl', 'calciferol', 'calcimagond', 'calcio', 'calciparine', 'calcipotriolbetamethasonmepha', 'calcitriol', 'calcium', 'calciumacetat', 'calciumacetatphosphatbinder', 'calciumcarbonat', 'calciumfolinat', 'calciumgluconat', 'calciumphosphatbinder', 'calcort', 'calcvita', 'callimon', 'calmedoron', 'calmerphanl', 'calmesinmepha', 'calobalin', 'calperos', 'calquence', 'calvakehl', 'calvive', 'camilia', 'campral', 'campto', 'cancidas', 'candesartan', 'candesartanamlodipinmepha', 'candsartan', 'canephron', 'canesten', 'cansartanmepha', 'capcitabine', 'capecitabin', 'capecitabinteva', 'caprelsa', 'caprisana', 'capsule', 'capsules', 'captosol', 'carbaglu', 'carbamid', 'carbamide', 'carbetocin', 'carbidopalevodopa', 'carbocifelan', 'carbolevure', 'carbonate', 'carboplatin', 'carboplatine', 'carboplatinteva', 'carbostesin', 'carboticon', 'carbovit', 'cardiax', 'cardinorma', 'cardiodoron', 'cardiogen', 'cardioral', 'cardiplant', 'cardo', 'cardura', 'cariban', 'carmenthin', 'carmol', 'carnitene', 'carsol', 'carvdilol', 'carvedilol', 'carvedilolmepha', 'carvedilolo', 'casodex', 'caspofungin', 'caspofungine', 'caspofunginmepha', 'catapresan', 'caverject', 'cayston', 'ceclor', 'cedur', 'cefamadar', 'cefavora', 'cefazolin', 'cefepim', 'cefepime', 'cefpodoxim', 'cefpodoxime', 'ceftriaxon', 'ceftriaxonacino', 'ceftriaxone', 'cefuroxim', 'cefuroxima', 'cefuroximacino', 'cefuroximmepha', 'cegrovit', 'celebrex', 'celecoxib', 'celecoxibmepha', 'celestone', 'cellcept', 'cellufluid', 'celluvisc', 'celsentri', 'cemisiana', 'ceprotin', 'cerazette', 'cerdelga', 'ceres', 'cerezyme', 'cerivikehl', 'cerivikehld', 'cernevit', 'cernvit', 'certican', 'cetallerg', 'ceteco', 'cetifelan', 'cetirizin', 'cetirizina', 'cetirizinmepha', 'cetmepha', 'cetrotide', 'cfazoline', 'cfpime', 'cfuroxime', 'champix', 'chardon', 'chenodeoxycholic', 'chenodesoxycholsure', 'china', 'chinabalsam', 'chinamed', 'chininsulfat', 'chirocaine', 'chirocane', 'chlorapreptm', 'chlorhexamed', 'chlorophylle', 'chloroprocain', 'chloroprocaine', 'chlorure', 'choleodoron', 'cholib', 'choriomon', 'cialis', 'cibinqo', 'ciclocutan', 'ciclopoli', 'ciloxan', 'cimifemin', 'cimifemine', 'cimzia', 'cinacalcet', 'cinacalcetmepha', 'cinnageron', 'cinqaero', 'cinryze', 'cip', 'cipralex', 'ciproflax', 'ciprofloxacin', 'ciprofloxacina', 'ciprofloxacine', 'ciprofloxacinmepha', 'ciproxin', 'ciproxine', 'circadin', 'circlet', 'circuvin', 'cisplatin', 'cisplatine', 'cisplatinteva', 'citalopram', 'citaloprammepha', 'citrafleet', 'citrate', 'citrokehl', 'clabin', 'claragine', 'clarelux', 'clariscan', 'clarithromycin', 'clarithromycine', 'clarithromycinmepha', 'claritine', 'claritinepollen', 'claritromicina', 'claromycin', 'claromycine', 'clcoxib', 'clensia', 'cleviprex', 'clexane', 'climavita', 'clindamycin', 'clindamycine', 'clindamycinmepha', 'clinoleic', 'clobetasol', 'clobex', 'clofara', 'clopidogrel', 'clopidogrelacino', 'clopidogrelmepha', 'clopidrax', 'clopin', 'clopixol', 'clorazepate', 'clorofilla', 'cloroprocaina', 'clottafact', 'clozapin', 'clozapinmepha', 'coamoxacino', 'coamoxicillin', 'coamoxicillina', 'coamoxicilline', 'coamoximepha', 'coaprovel', 'coatenolol', 'cobantril', 'cocandesartan', 'cocandsartan', 'cocculine', 'codafalgan', 'codein', 'codicalm', 'codicontin', 'codine', 'codiovan', 'coditussin', 'coenalapril', 'coepril', 'cohypert', 'cohypot', 'coirbesartan', 'coirbsartan', 'colatanoprost', 'colctab', 'coldistop', 'colifin', 'colisinopril', 'colisinoprilmepha', 'colistin', 'collirio', 'collublache', 'collypan', 'collyre', 'colocynthishomaccord', 'cololyt', 'colophos', 'colosan', 'colosartan', 'colpermin', 'combigan', 'combivir', 'combizym', 'combudoron', 'comiloridmephamite', 'comirnaty', 'competact', 'compresse', 'comprims', 'comtan', 'concerta', 'concor', 'condrosulf', 'condyline', 'confetti', 'constella', 'contractubex', 'contraschmerz', 'contredouleurs', 'contusingel', 'convulex', 'coolmesartan', 'coolmsartan', 'coop', 'copaxone', 'coramipril', 'cordarone', 'corisol', 'corocalm', 'corotrop', 'cortiment', 'cortinasal', 'corvaton', 'coryzalia', 'cosaar', 'cosentyx', 'cosopt', 'cosopts', 'cosyrel', 'cotellic', 'cotelmisartan', 'cotenololmepha', 'covalsartan', 'covaltanmepha', 'coveram', 'coversum', 'covid', 'cralonin', 'crampex', 'crataegisan', 'crataegitan', 'crataegus', 'crema', 'creon', 'creoncreon', 'cresemba', 'crestastatin', 'crestor', 'crilomus', 'crinone', 'crme', 'cromo', 'crysvita', 'ctirizine', 'cubicin', 'cuprior', 'cuprukehl', 'curakne', 'curanel', 'curatoderm', 'curosurf', 'cutaquig', 'cutasept', 'cutivate', 'cuvitru', 'cyanokit', 'cyclacur', 'cyclogyl', 'cyklokapron', 'cymbalta', 'cymevene', 'cypestra', 'cyproderm', 'cyramza', 'cystadrops', 'cystinol', 'cystoforce', 'cytarabin', 'cytarabine', 'cytosar', 'cytotec', 'cytotect', 'dacepton', 'dacin', 'dacogen', 'dafalgan', 'daflon', 'dafnegil', 'daivobet', 'daktarin', 'dalacin', 'dalmadorm', 'dancor', 'danisia', 'dantamacrin', 'dantrolen', 'daonil', 'daptomycin', 'daraprim', 'darmol', 'darunavir', 'darunavirmepha', 'darzalex', 'datscan', 'daunoblastin', 'daxas', 'dbridat', 'deaftol', 'deanxit', 'decadurabolin', 'decalcit', 'decapeptyl', 'decatylen', 'decoderm', 'defaeton', 'deferasirox', 'deferasiroxmepha', 'deferipron', 'defitelio', 'delamoxyl', 'delstrigo', 'demetrin', 'demogripal', 'demopectol', 'demotussol', 'demovarin', 'denosol', 'dentinox', 'dentohexin', 'dentohexine', 'depakine', 'depomedrol', 'deponit', 'depoprovera', 'deprivita', 'dequonal', 'dercut', 'dermacalmd', 'dermed', 'dermophil', 'dermovate', 'deroxat', 'descovy', 'desferal', 'desfral', 'desloratadin', 'desloratadina', 'desloratadine', 'desloratadinmepha', 'desofemono', 'desogyn', 'desogynelle', 'desomedin', 'desonur', 'desoren', 'detrusitol', 'deursil', 'dexafree', 'dexagentapos', 'dexamethason', 'dexamthasone', 'dexdor', 'dexeryl', 'dexilant', 'dexlansoprazoleacino', 'diacomit', 'dialgine', 'dialvit', 'dialvitcapsules', 'dialvitkapseln', 'diamicron', 'diamilla', 'diamox', 'diane', 'diaphin', 'diarrheel', 'diazepam', 'diazepammepha', 'dibase', 'dicetel', 'diclac', 'dicloabak', 'dicloacino', 'diclofenacmepha', 'diclofnacmepha', 'dicloren', 'dicloz', 'dicynone', 'dienogest', 'dienogestmepha', 'difenstulln', 'difenstullnud', 'differin', 'dificlir', 'diflucan', 'digestodoron', 'digifab', 'digoxinejuvis', 'digoxinjuvis', 'dilatrend', 'diltiazemmepha', 'dilzem', 'dinogest', 'diosmin', 'diovan', 'dipeptiven', 'diphtherie', 'dipiperon', 'diprogenta', 'diprophos', 'diprosalic', 'diprosone', 'disflatyl', 'dismenol', 'disoprivan', 'distickstoffoxid', 'distraneurin', 'diuresal', 'diurol', 'divigel', 'dobutrex', 'docetaxel', 'docetaxelteva', 'doctaxel', 'dogmatil', 'dolobene', 'dolocyl', 'dolokranit', 'dolospedifen', 'domperidon', 'domperidone', 'domperidonmepha', 'dompridone', 'donepezil', 'donepezilmepha', 'donpzil', 'dopamin', 'dopaview', 'doptelet', 'dormeasan', 'dormicum', 'dormiplant', 'dorzocompvision', 'dorzolamidetimolol', 'dorzolamidtimolol', 'dorzovision', 'dospir', 'dostinex', 'dotagraf', 'dotarem', 'dovato', 'doxazosin', 'doxazosincimex', 'doxiciclina', 'doxiciclinadoxiciclina', 'doxiproct', 'doxium', 'doxorubicin', 'doxorubicine', 'doxorubicinteva', 'doxyclin', 'doxyclindoxyclin', 'doxycline', 'doxyclinedoxycline', 'doxycyclinmepha', 'doxylag', 'doxysol', 'dr', 'drages', 'dretine', 'dretinelle', 'dropa', 'droperidol', 'dropridol', 'drosetux', 'drosinula', 'drossadin', 'drossafol', 'drovelis', 'dsomdine', 'duac', 'dualgin', 'ducressa', 'dukoral', 'dulcolax', 'duloxetin', 'duloxetina', 'duloxetinmepha', 'duloxtine', 'dulx', 'duodart', 'duodopa', 'duofer', 'duokopt', 'duoplavin', 'duosol', 'duotrav', 'duphalac', 'duphaston', 'dupixent', 'duraphat', 'durogesic', 'duspatalin', 'dutasterid', 'dutasteride', 'dutasteridetamsulosina', 'dutasteridtamsulosin', 'dutasteridtamsulosinmepha', 'dutastride', 'dutastridetamsulosine', 'dymista', 'dynamisan', 'dynamucil', 'dynexan', 'dysport', 'eau', 'ebixa', 'ebrantil', 'ecalta', 'echinacin', 'echinadoron', 'echinaforce', 'echinamed', 'echinarom', 'ecofenac', 'ecofnac', 'ecomucyl', 'edarbi', 'edarbyclor', 'edronax', 'edurant', 'efavirenz', 'efavirenzemtricitabintenofovir', 'efavirenzemtricitabintenofovirmepha', 'efavirenzmepha', 'efexor', 'effentora', 'effigel', 'effilevo', 'effortil', 'efient', 'efluelda', 'efudix', 'eklira', 'ektoselen', 'ektoslne', 'elaprase', 'eldisine', 'eletriptan', 'eletriptanmepha', 'elevit', 'elidel', 'eligard', 'eliquis', 'ellaone', 'elleacnelle', 'elmetacin', 'elmex', 'elmiron', 'elocom', 'elocta', 'eloine', 'elotrans', 'eloxatin', 'eloxatine', 'eltroxinelf', 'eltroxinlf', 'eludril', 'elvanse', 'elyfem', 'emadine', 'emedrin', 'emend', 'emgality', 'emla', 'emovate', 'empliciti', 'empressin', 'emselex', 'emser', 'emtricitabin', 'emtricitabina', 'emtricitabine', 'emtricitabintenofovir', 'emtricitabintenofovirmepha', 'emtriva', 'emulsione', 'enalapril', 'enalaprilhctmepha', 'enalaprilmepha', 'enapril', 'enavive', 'enbrel', 'enbrelenbrel', 'encepur', 'endoxan', 'enerzair', 'engerixb', 'engystol', 'enhertu', 'enspryng', 'enstilar', 'entecavir', 'entecavirmepha', 'entocort', 'entonox', 'entresto', 'entumin', 'entumine', 'entyvio', 'envarsus', 'eotriz', 'eparina', 'epclusa', 'ephdrine', 'ephedrin', 'ephynal', 'epiduo', 'epidyolex', 'epipenepipen', 'epirubicin', 'epirubicine', 'epirubicinteva', 'eplerenon', 'eplerenone', 'eplerenonmepha', 'eplrnone', 'epogam', 'epothetateva', 'eprex', 'epril', 'equasym', 'erbitux', 'erelzi', 'erelzierelzi', 'erivedge', 'erleada', 'erlotinib', 'ervebo', 'erythrocin', 'esbriet', 'escitalopram', 'escitaloprammepha', 'escitax', 'escotussin', 'esidrex', 'esketamin', 'esmeron', 'esmolol', 'esomep', 'esomeprazol', 'esomeprazolmepha', 'esomeprazolo', 'esomprazole', 'esoprax', 'esperoct', 'estalis', 'estinette', 'estradot', 'estrofem', 'etomidatlipuro', 'etopophos', 'etoposid', 'etoposide', 'etoricoxib', 'etoricoxibe', 'etoricoxibmepha', 'eucerin', 'euphorbium', 'euthyrox', 'evenity', 'evicel', 'eviplera', 'evista', 'evit', 'evra', 'evrysdi', 'evusheld', 'excipial', 'exelon', 'exelonpatch', 'exemestan', 'exemestano', 'exforge', 'exjade', 'exkivity', 'exmestane', 'exmykehl', 'exsepta', 'extraneal', 'eylea', 'ezetimib', 'ezetimibatorvastatinmepha', 'ezetimibe', 'ezetimibmepha', 'ezetimibrosuvastatin', 'ezetimibrosuvastatinmepha', 'ezetimibsimvastatinmepha', 'ezetrol', 'ezgas', 'eztimibe', 'fabrazyme', 'facteur', 'factor', 'faktor', 'faktu', 'fampyra', 'famvir', 'farlutal', 'farmorubicin', 'faros', 'farydak', 'fasenra', 'faslodex', 'fastum', 'fasturtec', 'feiba', 'felan', 'felden', 'felodipin', 'felodipinmepha', 'femadiolmepha', 'femara', 'femaraimportazione', 'femicin', 'femifect', 'feminac', 'feminelle', 'femiring', 'femoston', 'feniallerg', 'fenipic', 'fenistil', 'fenitoinagerot', 'fenivir', 'fentalis', 'fentanile', 'fentanyl', 'fentanylmepha', 'fentanylpiramal', 'feraccru', 'ferinject', 'fermed', 'ferofolic', 'ferriprox', 'ferro', 'ferrodona', 'ferrogradumet', 'ferrum', 'fertifol', 'fexo', 'fexofenadin', 'fexofenadine', 'fexofenadinmepha', 'fexofnadine', 'fexomepha', 'fiasp', 'fibrogammin', 'fibryga', 'filgrastimteva', 'finacapil', 'finasterax', 'finasterid', 'finasteride', 'finasteridmepha', 'finastride', 'fingolimodmepha', 'firazyr', 'firdapse', 'firmagon', 'fixaprost', 'fixateur', 'flagyl', 'flammazine', 'flamx', 'flatulex', 'flectoparin', 'flector', 'flodipine', 'florinef', 'floxal', 'floxapen', 'floxyfral', 'fluanxol', 'fluarix', 'flucazol', 'flucloxacillin', 'flucloxacilline', 'flucoderm', 'fluconax', 'fluconazol', 'fluconazole', 'fluconazolmepha', 'fluconazolo', 'fluctine', 'fludarabin', 'fludarabinteva', 'fludex', 'fluenz', 'fluidose', 'fluimucil', 'flumazenil', 'flumazenilmepha', 'fluomizin', 'fluoresceine', 'fluorescine', 'fluorocholine', 'fluorothyltyrosine', 'fluorouracil', 'fluorouracile', 'fluorouracilteva', 'fluorure', 'fluoxetin', 'fluoxetina', 'fluoxetinmepha', 'fluoxtine', 'flurbiangin', 'fluswan', 'flutiform', 'flutinase', 'fluvastatin', 'fluvastatine', 'fluvastatinmepha', 'fminac', 'fml', 'fmlneo', 'focalin', 'foclivia', 'folinate', 'folotyn', 'folvite', 'foradil', 'forene', 'formasan', 'forsteo', 'fortakehl', 'fortalis', 'fortam', 'fortecortin', 'fortevital', 'forxiga', 'fosamax', 'fosavance', 'foscarnet', 'foscavir', 'fosfolag', 'fosfomycin', 'fosfomycine', 'fosfomycinmepha', 'fosinoprilhctmepha', 'fosrenol', 'foster', 'fostimon', 'fragmin', 'fraxiforte', 'fraxiparine', 'frekaclyss', 'froben', 'fruttasan', 'fsmeimmun', 'fucicort', 'fucidin', 'fucithalmic', 'fulphila', 'fulvestrant', 'fulvestrantteva', 'fungizone', 'fungotox', 'fungx', 'furadantin', 'furadantine', 'furoate', 'furosemide', 'furospir', 'fusicutan', 'fuzocim', 'fycompa', 'gabapentin', 'gabapentine', 'gabapentinmepha', 'gadovist', 'galafold', 'galantamin', 'galvumet', 'galvus', 'gammanorm', 'ganfort', 'ganfortganfort', 'ganirelix', 'garamycin', 'gardasil', 'gaspan', 'gastricumeel', 'gastrografin', 'gatinar', 'gaviscon', 'gavisconell', 'gavreto', 'gazyvaro', 'gel', 'gelistop', 'gelodurat', 'gelomyrtol', 'gem', 'gemcitabin', 'gemcitabine', 'gemcitabinteva', 'gemmo', 'gempastiglie', 'gencydo', 'genotropin', 'gentos', 'genvoya', 'gerti', 'gevilon', 'ghrh', 'ghrhferring', 'gilenya', 'gincosan', 'ginkgo', 'ginkgobakehl', 'ginkgoforce', 'ginkgomepha', 'ginsana', 'ginsenosan', 'ginsor', 'giotrif', 'givlaari', 'glandosane', 'glatiramyl', 'glaupax', 'glibenorm', 'glibenorme', 'gliclazid', 'gliclazide', 'gliclazidmepha', 'glimepirid', 'glimepiridacino', 'glimepiride', 'glimerylmepha', 'glimpiride', 'glivec', 'glucagen', 'glucolyte', 'gluconate', 'gluconato', 'glucophage', 'glucosalin', 'glucosaline', 'glucose', 'glucosum', 'glupet', 'gluscan', 'glycerin', 'glycerinsuppositorien', 'glycerinzpfchen', 'glycophos', 'glycoramin', 'glycrine', 'glypressin', 'glypressine', 'glyxambi', 'gocce', 'goccew', 'gonalf', 'gorgonium', 'gouttes', 'gracial', 'grafalon', 'granisetron', 'granufink', 'grasustek', 'grazax', 'grefen', 'grippheel', 'grodurex', 'grofenac', 'gromazol', 'gutron', 'gynera', 'gynipral', 'gynocanesten', 'gynoflor', 'gynopevaryl', 'gynotardyferon', 'gyselle', 'haemate', 'haemocomplettan', 'haemoctin', 'haemopressin', 'halaven', 'halcion', 'haldol', 'halset', 'halsschmerzspray', 'hamamelis', 'hametum', 'hansaplast', 'harmonet', 'harpagomed', 'harvoni', 'havrix', 'hbner', 'hbvaxpro', 'hederix', 'heidak', 'helicobacter', 'helixor', 'helux', 'hemangiol', 'hemlibra', 'hemolingual', 'hemosol', 'hepagel', 'heparin', 'heparinna', 'hepas', 'hepatect', 'hepatitis', 'hepatodoron', 'hepaxane', 'hepeel', 'herbalance', 'herballerg', 'herceptin', 'herzuma', 'hexamedal', 'hextril', 'hexvix', 'hiberix', 'hibidil', 'hibiscrub', 'himapasta', 'hippuran', 'hirudoid', 'hizentra', 'hmofiltrationslsungen', 'hnseler', 'holgyeme', 'holoxan', 'homeovox', 'homogne', 'homoplasmine', 'hova', 'hpagel', 'hparine', 'huile', 'hukyndra', 'hulio', 'humalog', 'humaninsuline', 'humatin', 'humatrope', 'huminsulin', 'humira', 'hustentropfen', 'hycamtin', 'hydrocortison', 'hydrocortisone', 'hydrocortisonpos', 'hydrocortone', 'hydromorphone', 'hydromorphoni', 'hydroxycarbamid', 'hydroxycarbamide', 'hydroxychloroquine', 'hypericum', 'hyperiforce', 'hyperimed', 'hyperiplant', 'hyqvia', 'hyrimoz', 'hyrimozhyrimoz', 'hytrin', 'ialugen', 'ibandronat', 'ibandronate', 'ibandronatmepha', 'iberogast', 'ibrance', 'ibu', 'ibufelan', 'ibufenl', 'ibuprofen', 'ibuprofne', 'icatibant', 'ichtholan', 'iclusig', 'idacio', 'idelvion', 'idrossicarbamide', 'ig', 'ignatiahomaccord', 'ikervis', 'il', 'ilaris', 'ilomedin', 'ilumetri', 'imacort', 'imatinib', 'imatinibteva', 'imazol', 'imbruvica', 'imfinzi', 'imigran', 'imipenemcilastatin', 'imipenemcilastatinmepha', 'imlygic', 'immunate', 'immunine', 'imnovid', 'imodium', 'imovane', 'implanon', 'importal', 'imraldi', 'imukin', 'imurek', 'incruse', 'indapamid', 'indapamide', 'indapamidmepha', 'inderal', 'indigocarmin', 'indium', 'indivina', 'indocidretard', 'indophtal', 'inductos', 'inegy', 'infanrix', 'inflamac', 'inflectra', 'infludo', 'infludoron', 'influvac', 'inhalant', 'inhibace', 'inhixa', 'inhixainhixa', 'inlyta', 'inomax', 'inovelon', 'inrebic', 'insidon', 'inspra', 'instillagel', 'insuline', 'insulines', 'insuman', 'integrilin', 'intelence', 'intrarosa', 'intratect', 'intuniv', 'invanz', 'invega', 'invokana', 'iodure', 'ioduro', 'iomeron', 'iopamiro', 'iopidine', 'ipocol', 'ipramol', 'iqymune', 'irbesartan', 'irbesartanhctmepha', 'irbesartanmepha', 'irbsartan', 'iressa', 'irfen', 'irinotcan', 'irinotecan', 'irinotecanteva', 'iropect', 'irotussin', 'iscador', 'isentress', 'isofluran', 'isoket', 'isola', 'isoniazid', 'isoptin', 'isopto', 'isotretinoin', 'isotretinoinmepha', 'isturisa', 'isuprel', 'itinerol', 'itires', 'itracim', 'itraconazol', 'itraconazole', 'itraconazolmepha', 'itraconazolo', 'itraderm', 'itrazol', 'itulazax', 'ivabradin', 'ivabradine', 'ivemend', 'ivracain', 'ixiaro', 'jadenu', 'jakavi', 'janumet', 'januvia', 'jardiance', 'jarsin', 'jaydess', 'jeanine', 'jemperli', 'jentadueto', 'jetrea', 'jevtana', 'jext', 'jhp', 'jinarc', 'jivi', 'jorveza', 'juliette', 'juluca', 'jurnista', 'kadcyla', 'kadefemin', 'kadefemine', 'kaex', 'kafa', 'kalciposd', 'kaletra', 'kalinox', 'kalium', 'kaliumchlorid', 'kaliumiodid', 'kaliumphosphat', 'kaloba', 'kalydeco', 'kamillex', 'kamillin', 'kamillofluid', 'kamillosan', 'kanjinti', 'kanuma', 'kapanol', 'kcl', 'kefzol', 'kelimed', 'kelosoft', 'kemadrin', 'kenacort', 'kenacorta', 'kendural', 'kenergon', 'kengrexal', 'kentera', 'keppra', 'keppur', 'kerendia', 'kernosan', 'kesimpta', 'ketalar', 'ketalgin', 'ketamin', 'ketesse', 'ketomed', 'ketovision', 'ketozolmepha', 'kevzara', 'keytruda', 'kiovig', 'kirin', 'kisplyx', 'kisqali', 'kivexa', 'klacid', 'klaciped', 'kleanprep', 'klimaktoplant', 'kliogest', 'klisyri', 'klosterfrau', 'knzle', 'kodan', 'kombiglyze', 'konakion', 'korolind', 'koselugo', 'kosima', 'kovaltry', 'krenosin', 'krnosine', 'ktalgine', 'kuvan', 'kybernin', 'kyleena', 'kymriah', 'kyprolis', 'kytril', 'kytta', 'la', 'lacdigest', 'lacosamidmepha', 'lacrifluid', 'lacrinorm', 'lacrivision', 'lacrycon', 'lacryvisc', 'lactoferment', 'lactol', 'lactovis', 'ladonna', 'laitea', 'lamictal', 'lamisil', 'lamivudinteva', 'lamotrigin', 'lamotrigine', 'lamotrinmepha', 'lansol', 'lansoprax', 'lansoprazol', 'lansoprazole', 'lansoprazolmepha', 'lansoyl', 'lantus', 'lanvis', 'larifikehl', 'lasea', 'lasix', 'latanofta', 'latanoprost', 'latanoprostmepha', 'latanoprosttimolol', 'latanotimvision', 'latanovision', 'latuda', 'lavasept', 'laxasan', 'laxipeg', 'laxiplant', 'laxoberon', 'lebewohl', 'lecaponmepha', 'lecicarbon', 'lecigon', 'ledaga', 'ledermix', 'leflunomid', 'leflunomide', 'leflunomidmepha', 'legadyn', 'legalon', 'lemtrada', 'lenalidomid', 'lenalidomide', 'lenalidomidteva', 'lenvima', 'leponex', 'leqvio', 'lercanidipin', 'lercanidipina', 'lercanidipine', 'lercanidipinmepha', 'letrozol', 'letrozolo', 'letrozolteva', 'leucen', 'leucovorin', 'leucovorinteva', 'leukeran', 'leuprorelin', 'leuprorline', 'levacin', 'levemir', 'levetiracetam', 'levetiracetammepha', 'levex', 'levina', 'levitra', 'levocetirizin', 'levocetirizinmepha', 'levocetmepha', 'levodopabenserazid', 'levodopabenserazide', 'levofloxacin', 'levofloxacinacino', 'levofloxacinmepha', 'levomin', 'levonesse', 'levonorgestrel', 'levosert', 'lexotanil', 'lflunomide', 'lgalon', 'liberol', 'librax', 'librocol', 'libtayo', 'lidazon', 'lidco', 'lidocain', 'lidocaina', 'lidocane', 'lifoscrub', 'limbitrol', 'linezolid', 'linoforce', 'linola', 'linomed', 'linzolide', 'liohem', 'lioresal', 'liorsal', 'liosanne', 'lioton', 'lipactin', 'lipanthyl', 'lipercosyl', 'lipiodol', 'lipo', 'lipofundin', 'liposic', 'liquemin', 'liqumine', 'lisenia', 'lisinopril', 'lisinoprilmepha', 'lisitril', 'litak', 'litalir', 'lithiofor', 'liv', 'livazo', 'livial', 'livogiva', 'livostin', 'lixiana', 'lnalidomide', 'locacorten', 'locapred', 'locasalen', 'loceryl', 'locoid', 'locryl', 'lodine', 'lodotra', 'lodoz', 'logimax', 'lomir', 'lonsurf', 'loperamid', 'loperamide', 'loperamidmepha', 'lopramide', 'lopresor', 'loprsor', 'lorado', 'loramepha', 'loramet', 'loratadin', 'loratadine', 'loratinmepha', 'lorviqua', 'losartan', 'losartanhctmepha', 'losartanmepha', 'lotio', 'loxazol', 'lpolamidon', 'lponex', 'ltriptan', 'ltrozole', 'lubex', 'lubexyl', 'lucentis', 'lucrin', 'luffa', 'luffalobelia', 'luivac', 'lukair', 'lumigan', 'lumykras', 'lundeos', 'lur', 'lutathera', 'lutrelef', 'luveris', 'luvit', 'luvos', 'luxturna', 'lvoctirizine', 'lvodopabensrazide', 'lvofloxacine', 'lvonorgestrel', 'lvtiracetam', 'lvtiractam', 'lyfnua', 'lyman', 'lynparza', 'lyrica', 'lysodren', 'lysopain', 'lysopane', 'lyumjev', 'lyxumia', 'mabthera', 'macrogol', 'macrogolmepha', 'madinette', 'madopar', 'mag', 'magnesia', 'magnesio', 'magnesiocard', 'magnesium', 'magnesiumchlorid', 'magnesiumdiasporal', 'magnesiumsulfat', 'magnevist', 'magnsium', 'magnsiumdiasporal', 'makatussin', 'maku', 'malarone', 'maltofer', 'malveol', 'malvol', 'mannitol', 'maramentn', 'marcoumar', 'mariendistel', 'matrifen', 'mavenclad', 'mavi', 'maviret', 'maxalt', 'maxaltmaxalt', 'maxidex', 'maxitrol', 'mayzent', 'measles', 'mebucaine', 'mebucane', 'mebucaorange', 'mebucaspray', 'mebucherry', 'mediaven', 'medibudget', 'medikinet', 'medrol', 'mefenacid', 'mefenaminsure', 'mekinist', 'mektovi', 'melaleukapur', 'meliane', 'melix', 'meloden', 'melphalan', 'memantin', 'memantina', 'memantinmepha', 'memoria', 'menamig', 'meningitec', 'menomed', 'menopur', 'menopurmenopur', 'menosan', 'menveo', 'mepact', 'mephaangin', 'mephadolor', 'mephagrippal', 'mephameson', 'mephaquin', 'mepivacain', 'mercilon', 'merfen', 'meridol', 'merional', 'meronem', 'meropenem', 'mestinon', 'metadone', 'metaginkgo', 'metaheptachol', 'metalyse', 'metamizol', 'metamizolmepha', 'metamizolo', 'metamucil', 'metaneuron', 'metaossylen', 'metasinusit', 'metavirulent', 'metfin', 'metformin', 'metformina', 'metformine', 'metforminmepha', 'methadon', 'methergin', 'methotrexat', 'methotrexatmepha', 'methotrexatteva', 'methrexx', 'methylphenidat', 'methylphenidatmepha', 'methylthioniniumchlorid', 'metiltioninio', 'meto', 'metoflex', 'metofol', 'metoject', 'metolazon', 'metolazone', 'metopiron', 'metoprolol', 'metoprololacino', 'metoprololmepha', 'metoprololo', 'metrissa', 'metrolag', 'metronidazol', 'metronidazole', 'metvix', 'mevalotin', 'mezavant', 'mfnacide', 'mggranoral', 'mglongoral', 'mgoraleff', 'miacalcic', 'mianserinmepha', 'mibg', 'micardis', 'micardisplus', 'microbar', 'microgynon', 'microlax', 'micropaque', 'mictonet', 'mictonorm', 'midazolam', 'midro', 'mifegyne', 'miflonide', 'miglustat', 'milrinon', 'milrinone', 'milvane', 'mimpara', 'minalgin', 'minalgine', 'minerva', 'minesse', 'minirin', 'minitran', 'minjuvi', 'minocin', 'minorga', 'minulet', 'miochol', 'miostat', 'miranova', 'mircera', 'mirelle', 'mirena', 'mirtazapin', 'mirtazapina', 'mirtazapine', 'mirtazapinmepha', 'mirtazapmepha', 'mirvaso', 'misoone', 'mitem', 'mitoxantron', 'mitoxantrone', 'mivacron', 'mizzi', 'mmantine', 'mmrvaxpro', 'mobilat', 'moclo', 'modasomil', 'modigraf', 'mogadon', 'molaxole', 'mometason', 'mometasone', 'mometasonfuroat', 'mometasonmepha', 'momtasone', 'monofer', 'monoprost', 'monossido', 'monovo', 'monoxyde', 'montelukast', 'montelukastmepha', 'montlukast', 'monuril', 'morfina', 'morga', 'morphin', 'morphine', 'morphinhcl', 'morphini', 'motilium', 'moventig', 'movicol', 'moviprep', 'movymia', 'moxifloxacin', 'moxifloxacina', 'moxifloxacine', 'moxifloxacinmepha', 'mozobil', 'mretard', 'mst', 'mtamizole', 'mthadone', 'mthergin', 'mthotrexate', 'mthylphnidate', 'mtolazone', 'mtopirone', 'mtoprolol', 'mtronidazole', 'mucan', 'mucedokehl', 'mucilar', 'mucofluid', 'mucofor', 'mucogel', 'mucohm', 'mucokehl', 'mucomepha', 'mucosolvon', 'mucostop', 'mucox', 'mulimen', 'mulsion', 'multaq', 'multibic', 'multihance', 'multilind', 'mundipur', 'mundisal', 'muse', 'mutaflor', 'mutaflormite', 'muxol', 'mvasi', 'myambutol', 'mycamine', 'mycaminetm', 'mycobutin', 'myconormin', 'mycophenolatmofetil', 'mycophnolatemoftil', 'mycostatin', 'mycostatine', 'mycoster', 'mydocalm', 'mydrane', 'mydriasert', 'mydriaticum', 'myfenax', 'myfortic', 'myloop', 'mylotarg', 'myocholineglenwood', 'myoviewtm', 'myozyme', 'myrtaven', 'mysoline', 'myvlar', 'naabak', 'nacetylcysteine', 'nacl', 'naglazyme', 'nailcure', 'nalador', 'nalbuphin', 'nalcrom', 'naloxon', 'naltrexin', 'nanohsarotop', 'naproxenmepha', 'naramig', 'naropin', 'nasacort', 'nasensalbe', 'nasenspray', 'nasic', 'nasivin', 'nasivine', 'nasobol', 'nasofan', 'nasonex', 'natecal', 'natrium', 'natriumbicarbonat', 'natriumchlorid', 'natriumiodid', 'natuhepa', 'natulan', 'navelbine', 'navoban', 'nbivolol', 'nebido', 'nebilet', 'nebivolol', 'nebivololmepha', 'nebivololo', 'neisvacc', 'neoangin', 'neocitran', 'neogastx', 'neogyn', 'neosynephrinpos', 'neotigason', 'neotylol', 'nephrotrans', 'nerlynx', 'nerton', 'nervifene', 'nervifne', 'nervoheel', 'netspot', 'neulasta', 'neupogen', 'neupro', 'neuraceq', 'neurexan', 'neurodol', 'neurodoron', 'neurontin', 'neurorubin', 'nevanac', 'nevirapin', 'nevirapinmepha', 'nexavar', 'nexium', 'nexobrid', 'nexviadyme', 'nicardipin', 'nicorette', 'nicostopmepha', 'nicotinell', 'nieren', 'nifdipine', 'nifedipin', 'nifedipina', 'nifedipinmepha', 'nilemdo', 'nimbex', 'nimotop', 'ninlaro', 'nipruss', 'nisulid', 'nitroderm', 'nitrofurantoinacino', 'nitroglicerina', 'nitroglycerin', 'nitroglycrine', 'nitrolingual', 'nitux', 'nityr', 'nizoral', 'noctamid', 'nocutil', 'nodcongestine', 'nolvadex', 'nomercazole', 'nootropil', 'nopil', 'noradrenalin', 'noradrenalina', 'noradrenaline', 'noradrnaline', 'nordimet', 'norditropin', 'norditropine', 'norit', 'norlevo', 'normacol', 'normison', 'normisonmite', 'normisonnormison', 'normolytoral', 'normosang', 'norprolac', 'norsol', 'norvasc', 'norvir', 'notakehl', 'notta', 'novalgin', 'novaminsulfon', 'novantron', 'novesin', 'novocart', 'novoeight', 'novofem', 'novohelisen', 'novonorm', 'novorapid', 'novoseven', 'novothirteen', 'novothyral', 'noxafil', 'nozinan', 'nphrotrans', 'nplate', 'nubeqa', 'nucala', 'nulojix', 'numeta', 'nurofen', 'nustendi', 'nutraplus', 'nutriflex', 'nutrineal', 'nutryelt', 'nuvaring', 'nuvaxovid', 'nuwiq', 'nux', 'nvirapine', 'nyolol', 'nystalocal', 'nyxoid', 'oberland', 'obizur', 'obracin', 'ocaliva', 'ocrevus', 'octagam', 'octanate', 'octaplaslg', 'octaplex', 'octeniderm', 'octenimed', 'octenisept', 'octostim', 'octreoscan', 'octreotid', 'octreotidmepha', 'oculac', 'oculoheel', 'oculosan', 'odefsey', 'odomzo', 'oedemex', 'oestrogel', 'oestrogynaedron', 'ofev', 'ogivri', 'okoubasan', 'olanpax', 'olanzapin', 'olanzapina', 'olanzapine', 'olanzapinmepha', 'olanzapinteva', 'olbas', 'olbetam', 'olfen', 'olio', 'olmesartan', 'olmesartanamlodipinhctmepha', 'olmesartanamlodipinmepha', 'olmesartanhctmepha', 'olmesartanmepha', 'olmetec', 'olmsartan', 'ologyn', 'ologynelle', 'olumiant', 'omed', 'omegaflex', 'omegaven', 'omeprax', 'omepraxdrossapharm', 'omeprazol', 'omeprazolmepha', 'omeprazolo', 'omida', 'omidalin', 'omidaline', 'omix', 'omniscan', 'omnitrope', 'omprazole', 'onbrez', 'oncaspar', 'oncotice', 'oncovin', 'ondansetron', 'ondansetronteva', 'ondanstron', 'ondexxya', 'ongentys', 'onglyza', 'onguent', 'onivyde', 'onpattro', 'ontozry', 'ontruzant', 'onureg', 'opatanol', 'opdivo', 'opran', 'oprane', 'opsonat', 'opsumit', 'optava', 'opticrom', 'optiderm', 'optifen', 'optiray', 'oracea', 'oralair', 'oralpdon', 'oraqix', 'orencia', 'orfiril', 'orgalutran', 'orgaran', 'original', 'orkambi', 'orladeyo', 'orlistat', 'orlistatmepha', 'ornibel', 'osa', 'osanit', 'oscillococcinum', 'ospen', 'ospolot', 'ossicodone', 'ossopan', 'ossregen', 'osteocal', 'otalgan', 'otezla', 'otidolo', 'otipax', 'otri', 'otriduo', 'otrivin', 'ovaleap', 'ovestin', 'ovitrelle', 'ovixan', 'oxaliplatin', 'oxaliplatine', 'oxaliplatinteva', 'oxervate', 'oxis', 'oxlumo', 'oxybuprocaine', 'oxycodon', 'oxycodone', 'oxycodonenaloxone', 'oxycodonmepha', 'oxycodonnaloxon', 'oxycodonnaloxonmepha', 'oxycontin', 'oxynorm', 'oxyplastin', 'oxyplastine', 'oyavas', 'ozempic', 'ozurdex', 'pabal', 'paclitaxel', 'paclitaxelteva', 'padcev', 'padma', 'padmed', 'palexia', 'palforzia', 'paliperidon', 'paliperidonmepha', 'palipridone', 'palladon', 'palladonpalladon', 'palonosetron', 'palonosetronteva', 'palonostron', 'pamorelin', 'panadol', 'panadols', 'panax', 'panotile', 'panprax', 'pansekrel', 'pantofelan', 'pantogar', 'pantoprazol', 'pantoprazole', 'pantoprazoleacino', 'pantoprazolmepha', 'pantoprazolo', 'pantothenstreuli', 'pantozol', 'panzytrat', 'paracetafelan', 'paracetamol', 'paracetamolmepha', 'paracetamolo', 'paracodin', 'paraconica', 'paractamol', 'paragol', 'parapic', 'paraplatin', 'pariet', 'parlodel', 'paro', 'parodentosan', 'paronex', 'paroxetin', 'paroxetina', 'paroxetinmepha', 'paroxtine', 'parsabiv', 'parsenn', 'paspertin', 'pasta', 'pastiglie', 'pastilles', 'patent', 'patentblau', 'paxlovid', 'paya', 'pectocalmine', 'pectorex', 'pectus', 'peditrace', 'pefrakehl', 'pegasys', 'pelgraz', 'pelmeg', 'pelsano', 'pemazyre', 'pemetrexed', 'pemetrexedteva', 'pemzek', 'penicillin', 'pennsaid', 'pentacarinat', 'pentasa', 'pentavac', 'penthrox', 'pentoximepha', 'perenterol', 'perfalgan', 'pergoveris', 'perilox', 'perindopril', 'perindoprilamlodipinmepha', 'perindoprilindapamidmepha', 'perindoprilmepha', 'periochip', 'periolimelolimel', 'peritonealdialyselsungen', 'perjeta', 'perlinganit', 'permixon', 'perskindol', 'pertector', 'pertudoron', 'perustick', 'peterer', 'pethidin', 'petinimid', 'petinutin', 'pevaryl', 'pevisone', 'peyona', 'pharmaton', 'pheburane', 'phelinun', 'phenhydan', 'phenobarbital', 'phenylephrin', 'phenytoingerot', 'phesgo', 'phlebostasin', 'phnytonegerot', 'pholtussil', 'phoscap', 'phosphonorm', 'phosphorhomaccord', 'physiogel', 'physioneal', 'physiotens', 'phytomed', 'phytopharma', 'phytovir', 'picoprep', 'pifeltro', 'pigmanorm', 'pinikehl', 'pinimentholn', 'pioglitazon', 'pioglitazone', 'pioglitazonmepha', 'piperacillinatazobactam', 'piperacillinetazobactam', 'piperacillinetazobactamteva', 'piperacillintazobactam', 'piperacillintazobactamteva', 'pipracillinetazobactam', 'piqray', 'pirom', 'piroxicammepha', 'pitavastatin', 'pitavastatine', 'pitavastatinmepha', 'pivalone', 'pkmerz', 'plakout', 'plaquenil', 'plasmalyte', 'plavix', 'plegridy', 'plenadren', 'plendil', 'plenvu', 'plrnone', 'plus', 'pmtrexed', 'pneumovax', 'pnicilline', 'podomexef', 'poho', 'pohooel', 'polivy', 'polvac', 'polvactm', 'pomata', 'pommade', 'ponstan', 'ponvory', 'posaconazol', 'posaconazole', 'posaconazolo', 'posiformin', 'potassio', 'potassium', 'poteligeo', 'pradaxa', 'pradif', 'praluent', 'pramipexol', 'pramipexole', 'pramipexolmepha', 'pramipexolo', 'prasugrelmepha', 'pravastatin', 'pravastatina', 'pravastatine', 'pravastatinmepha', 'pravastax', 'praxbind', 'prazine', 'pred', 'prednicutan', 'prednisolon', 'prednisolone', 'prednison', 'prednisone', 'prednitop', 'prefemin', 'prefemine', 'pregabalin', 'pregabalina', 'pregabalinmepha', 'premandol', 'premavid', 'premens', 'pretufen', 'pretuval', 'prevenar', 'prevymis', 'prezista', 'prgabaline', 'priadel', 'prialt', 'pricktest', 'pricktestlsung', 'priligy', 'prilocain', 'prilox', 'primofenac', 'primofnac', 'primolut', 'primovist', 'primperan', 'primpran', 'prindopril', 'priorin', 'priorix', 'priorixtetra', 'prismasol', 'privigen', 'proaller', 'procain', 'procane', 'procoralan', 'proctoglyvenol', 'proctosynalar', 'procysbi', 'progestogel', 'proglicem', 'prograf', 'progynovaprogynova', 'prohance', 'prolastin', 'proleukin', 'prolia', 'prolutex', 'prontolax', 'propecia', 'propess', 'propofol', 'propofollipuro', 'propranolol', 'propycil', 'proquad', 'prorhinel', 'proscar', 'prospan', 'prospanex', 'prostadyn', 'prostagutt', 'prostaguttf', 'prostaplantf', 'prostasan', 'prostatonin', 'prostaurgenin', 'prostaurgnine', 'prostin', 'protagent', 'protamin', 'prothromplex', 'protopic', 'protossido', 'protoxyde', 'provokationstest', 'proxen', 'prurimed', 'psotriol', 'psychopax', 'pthidine', 'ptinimid', 'pulmex', 'pulmicort', 'pulmofor', 'pulmozyme', 'puregon', 'purinethol', 'pursana', 'pylera', 'pylori', 'pyralvex', 'pyrazinamide', 'qinlock', 'qlaira', 'qtern', 'quantalan', 'quentakehl', 'quetiapin', 'quetiapina', 'quetiapinmepha', 'quilonorm', 'quinsair', 'quitude', 'quofenix', 'qutenza', 'qutiapine', 'qvar', 'rabeprazol', 'rabipur', 'rabprazole', 'radicava', 'ramipril', 'ramiprilhctmepha', 'ramiprilmepha', 'ranexa', 'rapamune', 'rapidocain', 'rapifen', 'rapiscan', 'rasagilin', 'rasagilina', 'rasagiline', 'rasilez', 'rayaldee', 'reagila', 'rebalance', 'rebif', 'recofol', 'reconstituant', 'recormon', 'rectogesic', 'rectoseptal', 'rectoseptalneo', 'rectoseptalno', 'redi', 'redormin', 'redoxon', 'refacto', 'refixia', 'regaine', 'regenaplex', 'regiocit', 'rekambys', 'rekovelle', 'relaxane', 'relenza', 'relestat', 'relistor', 'relpax', 'relvar', 'remeron', 'remicade', 'remifentanil', 'reminyl', 'remodulin', 'remotiv', 'remsima', 'renacet', 'renagel', 'renelix', 'rennie', 'renvela', 'reparil', 'repatha', 'replagal', 'requiprequipmodutab', 'resiston', 'resolor', 'resonium', 'resorban', 'respadurr', 'respreeza', 'resyl', 'retrovir', 'retsevmo', 'revatio', 'revaxis', 'revestive', 'revlimid', 'revolade', 'rexulti', 'reyataz', 'rezirkane', 'rheumadoron', 'rheumalix', 'rhinallergy', 'rhinathiol', 'rhinitin', 'rhinocap', 'rhinogen', 'rhinostop', 'rhinx', 'rhipravent', 'rhophylac', 'rhumalgan', 'riamet', 'ribomustin', 'ricura', 'rifampicin', 'rifater', 'rifinah', 'rilutek', 'rimactan', 'rimactazid', 'rimstar', 'ringer', 'ringeracetat', 'ringeractate', 'ringerfundin', 'ringerlactat', 'ringerlactate', 'ringerlsung', 'rinofluimucil', 'rinoral', 'rinosedin', 'rinvoq', 'riopan', 'risperdal', 'risperidon', 'risperidonmepha', 'rispridone', 'ritalinela', 'ritalinla', 'rivastigmin', 'rivastigminacino', 'rivastigminmepha', 'rivoleve', 'rivotril', 'rixathon', 'rixubis', 'rizatriptan', 'rizatriptanmepha', 'roaccutan', 'robinulneostigmina', 'robinulneostigmine', 'robinulnostigmine', 'rocaltrol', 'rocephin', 'rocuronium', 'rohypnol', 'rombellin', 'ronapreve', 'ropinirol', 'ropinirole', 'ropinirolmepha', 'ropivacain', 'rosalox', 'rosuvastatin', 'rosuvastatina', 'rosuvastatine', 'rosuvastatinmepha', 'rosuvastax', 'rotarix', 'rotop', 'rotpunkt', 'rozlytrek', 'rparil', 'rsorbane', 'ruberkehl', 'rubraca', 'rubyfill', 'rudocain', 'rudocane', 'rudolac', 'rukobia', 'rybelsus', 'rybrevant', 'rydapt', 'rytmonorm', 'ryzodeg', 'sabcaps', 'sabril', 'saflutan', 'saizen', 'sal', 'salagen', 'salamol', 'salazopyrin', 'salbu', 'sale', 'salofalk', 'salvacyl', 'salvia', 'samsca', 'sanactiv', 'sanadermil', 'sanailmepha', 'sanalepsi', 'sanalgin', 'sandimmun', 'sandostatin', 'sandostatine', 'sangerol', 'sanguicimin', 'sanotuss', 'sanotussin', 'santasapina', 'santuril', 'sanukehl', 'sanuvis', 'sara', 'sarclisa', 'saridon', 'saroten', 'sativex', 'saxenda', 'sayana', 'scabimed', 'scandonest', 'scemblix', 'scheriproct', 'schmids', 'schoenenberger', 'schwedenmixtur', 'scintimun', 'sciroppo', 'sclerovein', 'scopolamine', 'seasonique', 'sebiprox', 'sebivo', 'sebolox', 'sedatif', 'sedazin', 'sedicelo', 'sedonium', 'seebri', 'seffalair', 'segluromet', 'sel', 'selectol', 'selenase', 'selenokehl', 'selincro', 'selobloc', 'selomida', 'sensicutan', 'septanest', 'septivon', 'septonsil', 'sequase', 'seractil', 'serdolect', 'seresta', 'seretide', 'serevent', 'seropram', 'seroquel', 'sertragen', 'sertralin', 'sertralina', 'sertraline', 'sertralinmepha', 'sevelamercarbonate', 'sevikar', 'sevoflurane', 'sevorane', 'sevredol', 'sevrelong', 'shingrix', 'sibelium', 'siccafluid', 'siccalix', 'siccaprotect', 'sicorten', 'sidovis', 'sidroga', 'siesta', 'sifrol', 'signifor', 'silacten', 'sildenafil', 'sildenafilmepha', 'sildenax', 'sildnafil', 'silkis', 'silvir', 'simbrinza', 'simcora', 'simdax', 'simeparacino', 'similasan', 'simimed', 'simponi', 'simulect', 'simvasin', 'simvasine', 'simvastatin', 'simvastatina', 'simvastatine', 'simvastatinmepha', 'sinemet', 'singulair', 'sintrom', 'sinudoron', 'sinupret', 'sinusin', 'sirdalud', 'sirop', 'skilarence', 'skinoren', 'skinsept', 'skyrizi', 'slenyto', 'smofkabiven', 'smoflipid', 'sodium', 'soffi', 'softacort', 'softasept', 'solacutan', 'solaraze', 'solarcane', 'solatran', 'solcogyn', 'solcoseryl', 'solevita', 'solian', 'solifenacin', 'solifenacina', 'solifenacinmepha', 'solifnacine', 'soliris', 'solmag', 'solmucalm', 'solmucane', 'solmucol', 'solucortef', 'solumedrol', 'solumoderin', 'soluprick', 'solution', 'solutions', 'soluvit', 'soluzione', 'somatuline', 'somavert', 'somcupin', 'somnofor', 'somprazole', 'songha', 'sonotryl', 'sonovue', 'soolantra', 'soporin', 'sorbisterit', 'sortis', 'sotalolmepha', 'sovaldi', 'spagymun', 'spagyrhin', 'spagyrom', 'spagyros', 'spasmex', 'spasmourgenin', 'spasmourgnine', 'spedifen', 'spedra', 'spersacarpine', 'spersadex', 'spersallerg', 'spersapolymyxin', 'spherox', 'spikevax', 'spinraza', 'spiolto', 'spiralgin', 'spiralgine', 'spiricort', 'spiriva', 'sporanox', 'sportium', 'sportusal', 'spravato', 'spray', 'sprycel', 'squamed', 'stalevo', 'staloral', 'stamaril', 'stamicis', 'steglatro', 'steglujan', 'stelara', 'stickoxydul', 'stickstoffmonoxid', 'stilamin', 'stilex', 'stilnox', 'stirnhhlentabletten', 'stivarga', 'stocrin', 'stodal', 'strattera', 'strensiq', 'strepsils', 'stribild', 'striverdi', 'structum', 'stugeron', 'suboxone', 'subutex', 'succicaptal', 'succinolin', 'sue', 'sufenta', 'sulfarlem', 'sulfate', 'sulgann', 'suliqua', 'sumatriptan', 'sumatriptanmepha', 'sun', 'sunitinib', 'sunitinibteva', 'supemtek', 'suppositoires', 'supposte', 'supracyclin', 'supracycline', 'supradyn', 'suprane', 'surmontil', 'sutent', 'suzanne', 'swancholin', 'swidro', 'sycrest', 'sylliv', 'sylvant', 'symbicort', 'symbioflor', 'symdeko', 'symfona', 'symfonel', 'symmetrel', 'symtuza', 'synacthen', 'synagis', 'synalar', 'synalarn', 'syntocinon', 'systen', 'tabrecta', 'tachosil', 'tacrocutan', 'tadalafil', 'tadalafilmepha', 'tafinlar', 'tagrisso', 'takhzyro', 'taloxa', 'taltz', 'talzenna', 'tambocor', 'tamec', 'tamiflu', 'tamoxifen', 'tamsulosin', 'tamsulosina', 'tamsulosine', 'tamsulosinmepha', 'tamsunax', 'tannosynt', 'taptiqom', 'tarceva', 'tardyferon', 'targin', 'targocid', 'tarka', 'tasigna', 'tasmar', 'taurolin', 'tavanic', 'tavegyl', 'tavolax', 'taxol', 'taxotere', 'tazobac', 'tears', 'tebofortin', 'tebokan', 'tecartus', 'tecentriq', 'teceos', 'tecfidera', 'technescan', 'teglutik', 'tegretol', 'tegsedi', 'teicoplanin', 'teinture', 'tekcis', 'tektrotyd', 'telebrix', 'telfast', 'telfastin', 'telmisartan', 'telmisartanhctmepha', 'telmisartanmepha', 'telzir', 'temestatemesta', 'temgesic', 'temodal', 'temozolomid', 'temozolomidteva', 'tenderdol', 'tenofovir', 'tenofovirmepha', 'tenoretic', 'tenormin', 'tepadina', 'tepmetko', 'terbifil', 'terbinafin', 'terbinafina', 'terbinafine', 'terbinafinmepha', 'terbinax', 'teriparatidmepha', 'terrosa', 'terzolin', 'tesalin', 'test', 'testavan', 'testogel', 'testoviron', 'tetagam', 'tetley', 'tetracaine', 'tetralysal', 'tetraspan', 'tetravac', 'teveten', 'tezspire', 'tgrtol', 'thallous', 'thiopental', 'thromboreductin', 'thymoglobuline', 'thyrogen', 'tiapridal', 'tiberal', 'tibolon', 'tibolone', 'tibolonmepha', 'tienam', 'tiger', 'tilcotil', 'tilur', 'tilurtilur', 'timocomod', 'timogel', 'timonil', 'timonilretard', 'timoptic', 'timopticxe', 'tinafine', 'tineafin', 'tineafine', 'tintura', 'tirosint', 'tisana', 'tisane', 'tisseel', 'tivicay', 'tlbrix', 'tnofovir', 'tobi', 'tobradex', 'tobrex', 'toctino', 'tolak', 'tollwutimpfstoff', 'tomudex', 'tonoglutal', 'tonopan', 'topamax', 'topiramat', 'topiramate', 'topiramatmepha', 'topiramato', 'toplexil', 'topotecan', 'topsym', 'toradol', 'torasemid', 'torasemide', 'torasemidmepha', 'torasmide', 'torem', 'tossamin', 'tossamine', 'tostran', 'toujeo', 'toviaz', 'toxex', 'toxogonin', 'trabar', 'tracleer', 'tracrium', 'tractocile', 'tracutil', 'trajenta', 'tramactil', 'tramadol', 'tramadolmepha', 'tramadolparacetamol', 'tramadolparacetamolmepha', 'tramadolparactamol', 'tramal', 'trandate', 'tranexam', 'transipeg', 'transtec', 'tranxilium', 'trasylol', 'traumalix', 'traumaplant', 'traumeel', 'travatan', 'travocort', 'travogen', 'travoprostmepha', 'travotimvision', 'travovision', 'trawell', 'trazimera', 'trazodon', 'trazodone', 'trecondi', 'trelegy', 'tremfya', 'treosul', 'treprostinil', 'tresiba', 'tretinac', 'treupel', 'trevicta', 'triamcort', 'triamject', 'triatec', 'triderm', 'triescence', 'triesence', 'trikafta', 'trilagavit', 'trileptal', 'trilipix', 'trimbow', 'trimipramin', 'trimipramine', 'triofan', 'triogen', 'trisenox', 'trisequens', 'trittico', 'triumeq', 'triveram', 'trixeo', 'trizivir', 'trodelvy', 'tropicamide', 'trprostinil', 'true', 'trulicity', 'trusopt', 'truvada', 'truxal', 'truxima', 'tukysa', 'tuscalman', 'tussaniln', 'tussantiol', 'tussex', 'twinrix', 'tyarena', 'tybost', 'tygacil', 'tylenol', 'tyroqualin', 'tyroqualine', 'tysabri', 'tyverb', 'ubistesintm', 'ultibro', 'ultiva', 'ultomiris', 'ultracain', 'ultracortenol', 'ultratechnekow', 'ultravist', 'uman', 'umckaloabo', 'undex', 'unguento', 'unguentolan', 'unifyl', 'upelva', 'uptravi', 'urapidil', 'urbanyl', 'uriconorm', 'uriconorme', 'urispas', 'urocit', 'urokinase', 'uromitexan', 'urorec', 'urotainer', 'urovaxom', 'ursochol', 'ursofalk', 'urticalcin', 'usneabasan', 'utrogestan', 'uvamin', 'vaborem', 'vabysmo', 'vaccin', 'vaccino', 'vagifem', 'vagihex', 'vagirux', 'valaciclovir', 'valaciclovirmepha', 'valacivirmepha', 'valcyte', 'valdoxan', 'valette', 'valganciclovir', 'valganciclovirmepha', 'valium', 'valproat', 'valproate', 'valsartan', 'valtanmepha', 'valtrex', 'valverde', 'vancocin', 'vancomycin', 'vancomycine', 'vaniqa', 'vannair', 'vardenafilmepha', 'varidoid', 'varilrix', 'varitect', 'varivax', 'vascord', 'vasokinox', 'vaten', 'vaxelis', 'vaxigriptetra', 'veblocema', 'vectibix', 'veklury', 'velbe', 'velcade', 'veletri', 'velphoro', 'veltassa', 'vemlidy', 'venavit', 'venclyxto', 'venlafaxin', 'venlafaxina', 'venlafaxine', 'venlafaxinmepha', 'venlafaxinmephaer', 'venlax', 'venofer', 'venofundin', 'venoruton', 'venostasin', 'ventavis', 'ventolin', 'venucremevenugel', 'venucrmevenugel', 'vepesid', 'veractiv', 'veraseal', 'veregen', 'verintex', 'verkazia', 'vermox', 'verquvo', 'verrumal', 'vertigoheel', 'verzenios', 'vesanoid', 'vesicare', 'vesoxx', 'veyvondi', 'vfend', 'viagra', 'vibramycin', 'vibravenoes', 'vibravens', 'vibrocil', 'viburcol', 'vicks', 'vicrin', 'victoza', 'vidaza', 'vide', 'videne', 'viferol', 'vigamox', 'vigor', 'vimizim', 'vimovo', 'vimpat', 'vinceel', 'vincristine', 'vincristinteva', 'vinorelbin', 'vinorelbine', 'viola', 'vipdomet', 'vipidia', 'viramune', 'viread', 'virgan', 'virucalm', 'virudermin', 'virudermingel', 'virupos', 'visanne', 'visannette', 'viscotears', 'viscum', 'visine', 'visipaque', 'vistabel', 'vistagan', 'visudyne', 'vita', 'vitaguarin', 'vitahexin', 'vital', 'vitalipid', 'vitamerfen', 'vitamin', 'vitamina', 'vitamine', 'vitango', 'vitarnin', 'vitarubin', 'vitarubine', 'vitasprint', 'vitrakvi', 'vividrin', 'vivotif', 'vizamyltm', 'vizimpro', 'vocabria', 'vokanamet', 'volibris', 'voltaren', 'voltarne', 'voltfast', 'voluven', 'voncento', 'voriconazol', 'voriconazole', 'voriconazolmepha', 'vosevi', 'votrient', 'votubia', 'votum', 'vpriv', 'vroni', 'vumerity', 'vyepti', 'vyndaqel', 'vyxeos', 'wakix', 'wala', 'waruzol', 'warzab', 'wecesin', 'wegovy', 'weleda', 'wellbutrin', 'wellvone', 'wgouttes', 'wiewohl', 'wilate', 'willfact', 'wonnensteiner', 'wtropfen', 'wundsalbe', 'xadago', 'xagrid', 'xalacom', 'xalatan', 'xalkori', 'xalos', 'xalosduo', 'xaluprine', 'xamiol', 'xanax', 'xarelto', 'xatral', 'xeljanz', 'xeloda', 'xenazine', 'xenetix', 'xenical', 'xeomin', 'xeplion', 'xermelo', 'xevudy', 'xgeva', 'xifaxan', 'xigduo', 'xofigo', 'xofluza', 'xolair', 'xorox', 'xospata', 'xospatatm', 'xprep', 'xtandi', 'xultophy', 'xylesin', 'xylo', 'xyloacino', 'xylocain', 'xylofelan', 'xylomepha', 'xyloneural', 'xylsine', 'xyrem', 'xyzal', 'yaldigo', 'yasmin', 'yasminelle', 'yaz', 'yellox', 'yervoy', 'yescarta', 'yira', 'yolienne', 'yondelis', 'zabak', 'zaditen', 'zaldiar', 'zaltrap', 'zanidip', 'zanipress', 'zarzio', 'zavedos', 'zavesca', 'zavicefta', 'zebinix', 'zeel', 'zeffix', 'zejula', 'zelboraf', 'zeller', 'zemplar', 'zentel', 'zenzi', 'zepatier', 'zeposia', 'zerbaxa', 'zestoretic', 'zestril', 'zevtera', 'ziagen', 'ziextenzo', 'zinacef', 'zinat', 'zincream', 'zinforo', 'zink', 'zinkokehl', 'zinplava', 'zintona', 'zirabev', 'zithromax', 'zocor', 'zoely', 'zofran', 'zolacin', 'zoladex', 'zolben', 'zoldorm', 'zoldronate', 'zoledronat', 'zoledronatteva', 'zoledronsure', 'zolgensma', 'zolmitriptan', 'zolmitriptanmepha', 'zoloft', 'zolpidem', 'zolpidemmepha', 'zometa', 'zomig', 'zomigzomig', 'zonegran', 'zonisamid', 'zonisamide', 'zopiclone', 'zostavax', 'zovirax', 'zrcher', 'ztimibe', 'zutectra', 'zyban', 'zyclara', 'zydelig', 'zykadia', 'zyloric', 'zyprexa', 'zyrtec', 'zytiga', 'zyvoxid'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.addmedTitle),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 30, 15, 15),
          child: Column(
            children: [
              Autocomplete<String>(optionsBuilder: (TextEditingValue textEditingValue) {
                if(textEditingValue.text==''){
                  return Iterable<String>.empty();
                }
                return med.where((String item) {
                  return item.contains(textEditingValue.text.toLowerCase());
                });

              },
              onSelected: (item) {
                print(item);
              },
              ),
              AddTextField(
                controller: nameController,
                title: AppLocalizations.of(context)!.medName,
                width: double.infinity,
                height: 60.0,
              ),
              SizedBox(
                height: space,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.medType),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            image = "pills.png";
                            print(image);
                          });
                        },
                        child: MedicineType(
                          image: "pills.png",
                          color: image == "pills.png"
                              ? Colors.green
                              : Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            image = "syrup.png";
                          });
                        },
                        child: MedicineType(
                          image: "syrup.png",
                          color: image == "syrup.png"
                              ? Colors.green
                              : Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            image = "syringe.png";
                          });
                        },
                        child: MedicineType(
                          image: "syringe.png",
                          color: image == "syringe.png"
                              ? Colors.green
                              : Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            image = "vitaminc.png";
                          });
                        },
                        child: MedicineType(
                          image: "vitaminc.png",
                          color: image == "vitaminc.png"
                              ? Colors.green
                              : Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: space,
              ),
              AddTextField(
                controller: dosageController,
                title: AppLocalizations.of(context)!.dosage,
                width: double.infinity,
                height: 60.0,
              ),
              SizedBox(
                height: space,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _selectDate(context, true);
                        },
                        child: InfoContainer(
                          title: AppLocalizations.of(context)!.start,
                          info:
                              "${DateFormat('dd MMM yyyy').format(startDate)}",
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _selectDate(context, false);
                        },
                        child: InfoContainer(
                          title: AppLocalizations.of(context)!.end,
                          info: "${DateFormat('dd MMM yyyy').format(endDate)}",
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: space,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _selectTime(context);
                        },
                        child: InfoContainer(
                          title: AppLocalizations.of(context)!.time,
                          info: "${time.format(context)}",
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.of(context)!.freq),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            height: 38,
                            width: 100,
                            child: Center(
                              child: DropdownButton(
                                value: dropdownvalue,
                                iconSize: 0.0,
                                underline: SizedBox(),
                                items: items.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownvalue = newValue!;
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: space,
                  ),
                  AddTextField(
                    controller: noteController,
                    title: AppLocalizations.of(context)!.note,
                    width: double.infinity,
                    height: 60.0,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () async {
                      DateFormat dateFormat = DateFormat('dd.MM.yyyy');
                      DateTime s = DateTime.utc(
                          startDate.year, startDate.month, startDate.day);
                      List dateList = [];
                      List dateListTime = [];
                      while (endDate.difference(s).inDays >= 0) {
                        setState(() {
                          dateList.add(dateFormat.format(s));
                          dateListTime.add(s.add(Duration(
                              hours: time.hour, minutes: time.minute)));
                          if (dropdownvalue ==
                              AppLocalizations.of(context)!.weekly) {
                            s = s.add(Duration(days: 7));
                          } else if (dropdownvalue ==
                              AppLocalizations.of(context)!.daily) {
                            s = s.add(Duration(days: 1));
                          } else {
                            s = DateTime(s.year, s.month + 1, s.day);
                          }
                        });
                      }
                      print(dateListTime[0].toString());

                      List boolList = [];
                      for (var i = 0; i < dateList.length; i++) {
                        boolList.add(false);
                      }
                      final data = {
                        'name': nameController.text,
                        'image': image,
                        'dosage': dosageController.text,
                        'time': time.minute < 10
                            ? '${time.hour}:0${time.minute}'
                            : '${time.hour}:${time.minute}',
                        'note': noteController.text,
                        'dates': dateList,
                        'completed': boolList,
                        'frequency': dropdownvalue,
                      };
                      await db.collection(userid).doc().set(data);

                      for(int i =0;i<dateListTime.length;i++)  {
                        await NotificationApi.showScheduledNotification(
                          title: nameController.text,
                          body: "It's time to take your medicine",
                          scheduledDate: DateTime.parse(dateListTime[i]
                              .toString()
                              .replaceAll(":00.000Z", "")));

                      }
                      
                      
                      
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 160.0,
                      height: 45.0,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.addmed,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
