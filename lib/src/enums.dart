/// Enums below are based from JMdict file lines 247-491

/// Regional Dialects
enum Dialect {
  bra,  /// Brazilian
  hcb,  /// Hokkaido-ben
  ksb,  /// Kansai-ben
  ktb,  /// Kantou-ben
  kyb,  /// Kyoto-ben
  kyu,  /// Kyuushuu-ben
  nab,  /// Nagano-ben
  obs,  /// Osaka-ben
  rkb,  /// Ryuukyuu-ben
  thb,  /// Touhoku-ben
  tsb,  /// Tosa-ben
  tsug, /// Tsugaru-ben
}

/// Information about the field of application of the entry/sense
enum SenseField {
  agric,  /// agriculture
  anat, /// anatomy
  archeol,  /// archeology
  archit, /// architecture
  art,  /// art, aesthetics
  astron, /// astronomy
  audvid, /// audiovisual
  aviat,  /// aviation
  baseb,  /// baseball
  biochem,  /// biochemistry
  biol, /// biology
  bot,  /// botany
  Buddh,  /// Buddhism
  bus,  /// business
  chem, /// chemistry
  Christn,  /// Christianity
  cloth,  /// clothing
  comp, /// computing
  cryst,  /// crystallography
  ecol,  /// ecology
  econ, /// economics
  elec, /// electricity, elec. eng.
  electr, /// electronics
  embryo, /// embryology
  engr, /// engineering
  ent,  /// entomology
  finc, /// finance
  fish, /// fishing
  food, /// food, cooking
  gardn,  /// gardening, horticulture
  genet,  /// genetics
  geogr,  /// geography
  geol, /// geol
  geom, /// geom
  go, /// go (game)
  golf, /// golf
  gramm,  /// grammar
  grmyth, /// Greek mythology
  hanaf,  /// hanafuda
  horse,  /// horse racing
  law,  /// law
  ling, /// linguistics
  logic,  /// logic
  MA, /// martial arts
  mahj, /// mahjong
  math, /// mathematics
  mech, /// mechanical engineering
  med,  /// medicine
  met,  /// meteorology
  mil,  /// military
  music,  /// music
  ornith, /// ornithology
  paleo,  /// paleontology
  pathol, /// pathology
  pharm,  /// pharmacy
  phil, /// philosophy
  photo, /// photography
  physics,  /// physics
  physiol,  /// physiology
  print,  /// printing
  psy,  /// psychiatry
  psych,  /// psychology
  rail, /// railway
  Shinto, /// Shinto
  shogi,  /// shogi
  sports, /// sports
  stat, /// statistics
  sumo, /// sumo
  telec,  /// telecommunications
  tradem, /// trademark,
  vidg, /// videoGames
  zool, /// zoology
}

/// Additional information of a kanji, typically indicates some unusual aspects
enum KanjiInfo {
  ateji,  /// ateji (phonetic) reading
  ik,   /// word containing irregular kana usage
  iK, /// word containing irregular kanji usage
  io, /// irregular okurigana usage
  oK, /// word containing out-dated kanji or kanji usage
  rK, /// rarely-used kanji form
}

/// Used for other relevant information about the entry/sense. Usually apply to several senses
enum SenseMiscellaneous {
  abbr, /// abbreviation
  arch, /// archaism
  char, /// character
  chn,  /// children's language
  col,  /// colloquialism
  company,  /// company name
  creat,  /// creature
  dated,  /// dated term
  dei,  /// deity
  derog,  /// derogatory
  doc,  /// document
  ev, /// event
  fam,  /// familiar language
  fem,  /// female term of language
  fict, /// fiction
  form, /// formal or literary term
  given,  /// given name or forename, gender not specified
  group,  /// group
  hist, /// historical
  hon,  /// honorific or respectful (sonkeigo) language
  hum,  /// humble (kenjougo) language
  id, /// idiomatic expression
  joc,  /// jocular, humorous term
  leg,  /// legend
  m_sl, /// manga slang
  male, /// male term of language
  myth, /// mythology
  net_sl, /// Internet slang,
  obj,  /// object
  obs,  /// obsolete term
  obsc, /// obscure term
  on_mim, /// onomatopoeic or mimetic word,
  organization, /// organization name
  oth,  /// other
  person, /// full name of a particular person
  place,  /// place name
  poet, /// poetical term
  pol,  /// polite (teineigo) language
  product,  /// product name,
  proverb,  /// proverb
  quote,  /// quotation
  rare, /// rare
  relig,  /// religion
  sens, /// sensitive
  serv, /// service
  sl, /// slang
  station,  /// railway station
  surname,  /// surname
  uk, /// word usually written using kana alone
  unclass,  /// unclassified name
  vulg,   /// vulgar
  work, /// work of art, literature, music, etc. name
  X,  /// rude or X-rated term (not displayed in educational software)
  yoji, /// yojijukugo
}

enum PartOfSpeech {
  adj_f, /// noun or verb acting prenominally
  adj_i, /// adjective (keiyoushi)
  adj_ix,  /// adjective (keiyoushi) - yoi/ii class
  adj_kari,  /// 'kari' adjective (archaic)
  adj_ku,  /// 'ku' adjective (archaic)
  adj_na,  /// adjectival nouns or quasi-adjectives (keiyodoshi)
  adj_nari,  /// archaic/formal form of na-adjective
  adj_no,  /// nouns which may take the genitive case particle 'no'
  adj_pn,  /// pre-noun adjectival (rentaishi)
  adj_shiku, /// 'shiku' adjective (archaic)
  adj_t, /// 'taru' adjective
  adv,  /// adverb (fukushi)
  adv_to,  /// adverb taking the 'to' particle
  aux,  /// auxiliary
  aux_adj, /// auxiliary adjective
  aux_v, /// auxiliary verb
  conj, /// conjunction
  cop,  /// copula
  ctr,  /// counter
  exp,  /// expressions (phrases, clauses, etc.)
  int,  /// interjection (kandoushi)
  n,  /// noun (common) (futsuumeishi)
  n_adv, /// adverbial noun (fukushitekimeishi)
  n_pr,  /// proper noun
  n_pref,  /// noun, used as a prefix
  n_suf, /// noun, used as a suffix
  n_t, /// noun (temporal) (jisoumeishi)
  num,  /// numeric
  pn, /// pronoun
  pref, /// prefix
  prt,  /// particle
  suf,  /// suffix
  unc,  /// unclassified
  v_unspec,  /// verb unspecified
  v1, /// Ichidan verb
  v1_s,  /// Ichidan verb - kureru special class
  v2a_s, /// Nidan verb with 'u' ending (archaic)
  v2b_k, /// Nidan verb (upper class) with 'bu' ending (archaic)
  v2b_s, /// Nidan verb (lower class) with 'bu' ending (archaic)
  v2d_k, /// Nidan verb (upper class) with 'dzu' ending (archaic)
  v2d_s, /// Nidan verb (lower class) with 'dzu' ending (archaic)
  v2g_k, /// Nidan verb (upper class) with 'gu' ending (archaic)
  v2g_s, /// Nidan verb (lower class) with 'gu' ending (archaic)
  v2h_k, /// Nidan verb (upper class) with 'hu/fu' ending (archaic)
  v2h_s, /// Nidan verb (lower class) with 'hu/fu' ending (archaic)
  v2k_k, /// Nidan verb (upper class) with 'ku' ending (archaic)
  v2k_s, /// Nidan verb (lower class) with 'ku' ending (archaic)
  v2m_k, /// Nidan verb (upper class) with 'mu' ending (archaic)
  v2m_s, /// Nidan verb (lower class) with 'mu' ending (archaic)
  v2n_s, /// Nidan verb (lower class) with 'nu' ending (archaic)
  v2r_k, /// Nidan verb (upper class) with 'ru' ending (archaic)
  v2r_s, /// Nidan verb (lower class) with 'ru' ending (archaic)
  v2s_s, /// Nidan verb (lower class) with 'su' ending (archaic)
  v2t_k, /// Nidan verb (upper class) with 'tsu' ending (archaic)
  v2t_s, /// Nidan verb (lower class) with 'tsu' ending (archaic)
  v2w_s, /// Nidan verb (lower class) with 'u' ending and 'we' conjugation (archaic)
  v2y_k, /// Nidan verb (upper class) with 'yu' ending (archaic)
  v2y_s, /// Nidan verb (lower class) with 'yu' ending (archaic)
  v2z_s,  /// Nidan verb (lower class) with 'zu' ending (archaic)
  v4b,  /// Yodan verb with 'bu' ending (archaic)
  v4g,  /// Yodan verb with 'gu' ending (archaic)
  v4h,  /// Yodan verb with 'hu/fu' ending (archaic)
  v4k,  /// Yodan verb with 'ku' ending (archaic)
  v4m,  /// Yodan verb with 'mu' ending (archaic)
  v4n,  /// Yodan verb with 'nu' ending (archaic)
  v4r,  /// Yodan verb with 'ru' ending (archaic)
  v4s,  /// Yodan verb with 'su' ending (archaic)
  v4t,  /// Yodan verb with 'tsu' ending (archaic)
  v5aru,  /// Godan verb - -aru special class
  v5b,  /// Godan verb with 'bu' ending
  v5g,  /// Godan verb with 'gu' ending
  v5k,  /// Godan verb with 'ku' ending
  v5k_s, /// Godan verb - Iku/Yuku special class
  v5m,  /// Godan verb with 'mu' ending
  v5n,  /// Godan verb with 'nu' ending
  v5r,  /// Godan verb with 'ru' ending
  v5r_i, /// Godan verb with 'ru' ending (irregular verb)
  v5s,  /// Godan verb with 'su' ending
  v5t,  /// Godan verb with 'tsu' ending
  v5u,  /// Godan verb with 'u' ending
  v5u_s, /// Godan verb with 'u' ending (special class)
  v5uru,  /// Godan verb - Uru old class verb (old form of Eru)
  vi, /// intransitive verb
  vk, /// Kuru verb - special class
  vn, /// irregular nu verb
  vr, /// irregular ru verb, plain form ends with -ri
  vs, /// noun or participle which takes the aux. verb suru
  vs_c,  /// su verb - precursor to the modern suru
  vs_i,  /// suru verb - included
  vs_s,  /// suru verb - special class
  vt, /// transitive verb
  vz, /// Ichidan verb - zuru verb (alternative form of -jiru verbs)
}

enum ReadingInfo {
  gikun,  /// gikun (meaning as reading) or jukujikun (special kanji reading)
  ik, /// word containing irregular kana usage
  ok, /// out-dated or obsolete kana usage
  uK, /// word usually written using kanji alone
}

enum SenseLanguage {
  eng,  /// English
  ger,  /// Germany
  rus,  /// Russian
  spa,  /// Spanish
  hun,  /// Hungarian
  slv,  /// Slovenian
  dut,  /// Dutch
}

enum SourceLanguageType {
  full,
  part, /// partial
}

enum GlossaryType {
  lit,  /// literal
  fig,  /// figurative
  expl, /// explanation
}

enum ReadingPriority {
  news1,  /// first 12,000 words of "wordfreq" from Mainichi Shinbun
  news2,  /// the remaining 12,000 words from "wordfreq" from Mainichi Shinbun
  ichi1,  /// appears in the "Ichimango goi bunruishuu", Senmon Kyouiku Publishing, Tokyo, 1998.
  ichi2,  /// demoted from ichi1 because they were observed to have low frequencies in the WWW and newspapers
  spec1,  /// detected as being common, but are not included in other lists
  spec2,  /// spec1 extension
  gai1, /// common loanwords based on the wordfreq file
  gai2, /// gai1 extension

  /// indicator of frequency-of-use ranking.
  /// "xx" is the number of the set of 500 words in which
  /// the entry can be found, with "01" assigned to the first 500, "02"
  /// to the second, and so on. (The entries with news1, ichi1, spec1, spec2
  /// and gai1 values are marked with a "(P)" in the EDICT and EDICT2
  /// files.
  nf,
}