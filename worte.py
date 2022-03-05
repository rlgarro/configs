import signal, sys
from os.path import expanduser


HOME= expanduser("~")

worte_id_xml = "<aktuellerWorteId>{}</aktuellerWorteId>\n"

WORTEEINTRAG_TAG = "<worteeintrag>\n"
WORTEEINTRAG_TAG_END = "</worteeintrag>\n\n"
ZEIT_TAG = "    <zeiteintragtag>{}</zeiteintragtag>\n"
WORTE_TAG = "   <worte>\n"
WORTE_TAG_END = "   </worte>\n"
WORT_TAG="      <wort anki=\"{}\" index=\"{}\" art=\"{}\" bedeutung=\"{}\" plural=\"{}\">{}</wort>\n"

MENU_OPTIONEN_FRAGE="Was wollen Sie zu tun? \n [1] - Neue Worteeintrag \n [2] - Programm verlassen \n [3] - Worteeintrag bearbeiten\n Ihre option: "
MENU_OPTIONEN_FALSCH_ANTWORT="Bitte geben Sie nur ein 1 oder ein 2 \n"

WORT_OPTIONEN_FRAGE="Bitte wählt aus: \n [1] - Neue wort \n [2] - Worteeintrag enden \n Ihre option: "

ZEIT_EINTRAG_FRAGE="Zeit: "
ANKI_EINTRAG_FRAGE="ANKI w/f: "
ANKI_EINTRAG_FASLCH="Bitte geben Sie nur w für wahr oder f für faslch."

ART_EINTRAG_FRAGE="Art: \n [1] - verb \n [2] - subs \n [3] - adj \n [4] - adv \n [5] - conj \n Ihre option: "
BEDEUTUNG_EINTRAG_FRAGE="Bedeutung: "
PLURAL_EINTRAG_FRAGE="Plural: "
WORT_EINTRAG_FRAGE="Wort: "

WEG_OPTION_NACHRICHT="\nSie haben verlassen ausgewählt, programm beendet."


index=0
linier=[]

PATH = "{}/worte".format(HOME)
def datei_öffnen():
    global file
    if os.path.exists(PATH):
        file = open(PATH, "r")


def alle_linier_aktualisieren():
    global linier
    file = open(PATH, "w")
    file.writelines(linier)
    linier = []
    file.close()

def xml_ids_aktualisieren():
    linier[0] = worte_id_xml.format(index)


def global_index_aktualisieren(n):
    global index
    if n > 0:
        index += n

def global_index_setzen():
    global index
    global linier

    # worte index setzen
    if len(linier) == 0:
        index = 1
        linier.append(worte_id_xml.format(index))

    else:
        line = linier[0]
        index = int(line.split(">")[1].split("<")[0])



def wort_erstellen(anki,index,art, bedeutung, plural,wort):
    return WORT_TAG.format(anki,index,art,bedeutung,plural,wort)

def wort_schreiben(wort):
    # wort um ende von worteeintrag schreiben
    linier.append(wort)

def neue_wort_schreiben():

    # wort
    wort=input(WORT_EINTRAG_FRAGE)

    # art
    art=art_bekommen()

    # bedeutung
    bedeutung=input(BEDEUTUNG_EINTRAG_FRAGE)

    # ankieintrag
    anki=input(ANKI_EINTRAG_FRAGE)
    while anki != "w" and anki != "f":
        print(ANKI_EINTRAG_FASLCH)
        anki=input(ANKI_EINTRAG_FRAGE)
    anki = "wahr" if anki == "w" else "falsch"

    plural=""
    if art == "subs":
        # plural
        plural=input(PLURAL_EINTRAG_FRAGE)

    global_index_aktualisieren(1)
    wort_tag=wort_erstellen(anki,index,art,bedeutung,plural,wort)

    wort_schreiben(wort_tag)
    print("Wort wurde gespeichert \n")


def worteeintragtag_schreiben(eröffnung):
    if eröffnung == False:
        linier.append(WORTEEINTRAG_TAG_END)
    else:
        linier.append(WORTEEINTRAG_TAG)

def zeiteintragtag_schreiben():
    zeit = input(ZEIT_EINTRAG_FRAGE)
    linier.append(ZEIT_TAG.format(zeit)) 

def wortetag_schreiben(eröffnung):
    if eröffnung == False:
        linier.append(WORTE_TAG_END)
    else:
        linier.append(WORTE_TAG)

def art_bekommen():
    n = int(input(ART_EINTRAG_FRAGE))
    while n < 1 and n > 5:
        n = int(input(ART_EINTRAG_FRAGE))

    if n == 1:
        return "verb"
    if n == 2:
        return "subs"
    if n == 3:
        return "adj"
    if n == 4:
        return "adv"
    if n == 5:
        return "conj"

def neue_worteeintrag():
    while True:
        ist_eintrag=int(input(MENU_OPTIONEN_FRAGE))
        while ist_eintrag != 1 and ist_eintrag != 2:
            print(OPTIONEN_FALSCH_ANTWORT)
            ist_eintrag=input(MENU_OPTIONEN_FRAGE)
            print('\n')

        if ist_eintrag == 2:
            print(WEG_OPTION_NACHRICHT)
            break

        worteeintragtag_schreiben(True)
        zeiteintragtag_schreiben()
        wortetag_schreiben(True)
        neue_wort_schreiben() # man darf nicht verlassen, ohne zumindest 1 Wort schreiben.
        while True:
            ist_wort=int(input(WORT_OPTIONEN_FRAGE))
            while ist_wort != 1 and ist_wort != 2:
                print(OPTIONEN_FALSCH_ANTWORT)
                ist_wort=int(input(WORT_OPTIONEN_FRAGE))

            if ist_wort == 2:
                wortetag_schreiben(False)
                worteeintragtag_schreiben(False)
                break

            neue_wort_schreiben()

def signal_handler(sig, frame):
    print('\nProgramm geendet')
    sys.exit(0)

def file_existiert():
    global file
    try:
        file
    except NameError:
        return False

    return True

if __name__ == '__main__':
    signal.signal(signal.SIGINT, signal_handler)
    global_index_setzen()
    original_index = index
    neue_worteeintrag()
    if original_index != index:
        xml_ids_aktualisieren()
        alle_linier_aktualisieren()

    elif file_existiert():
        file.close()

