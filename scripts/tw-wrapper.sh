#!/bin/bash

# Erstens muessen wir wissen, was gemacht werden moechte.
# Zum Auswählen stehen: 
# 1 Erstellen CC/Bug, 
# Frag nach Nummer, Kunde, Formatte (Asistida, SSCO, Selfscan), sind Rabatten beinhaltet/betroffen?
# Ist es etwas fiscales? Etwas mit Zahlungsmittel?

# 2 Bearbeiten CC/Bug, 
# 3 Kommende Deadlines:

# Pro CC:
# Lese von allen CCs ab, welche Deadlines die haben und gebe diese aus aufgewiesen werden sollte.
# Nach QA:
# Nach Impl:
# Nach Kunde:

# 4 Unerledigtes eines CCs 
# 1 - Frag nach CC
# 5 Unerledigtes (alles)


haupt_menu="
Optionen:

   [1] - Erstellen CC/Bug
   [2] - Bearbeiten CC/Bug (nicht implementiert)
   [3] - Kommende Deadlines
   [4] - Unerledigtes eines CCs
   [5] - Unerledigtes (alles)
   [6] - Erledigtes (alles)
   [7] - Auflisten und in Datei - Liste alles und biete an, die Datei anzuschauen falls es eine gibt
"
check_dependency() {
    bin_path=$(which task 2>/dev/null)
    if [[ -z $bin_path ]]; then
        echo "Command not found, exiting.."
        exit 1
    else
        echo "Found binary: $bin_path"
    fi
}

check_dependency

echo -e "$haupt_menu"
echo 
read -p "Auswahl: " auswahl
echo " "



# Functions
check_existing_project() {
    exists=$(task list project:$1 2> /dev/null)
    if [[ $exists ]]; then
        return 0
    else
        return 1
    fi
}

create_task_project() {
    echo $#
    task add "$2 $1 - Hauptseite" project:"$1" customer:"$2" +cc dev_deli:"$3" qa_deli:"$4" imp_deli:"$5"
}

create_project() {
    read -p "$projekt_nummer_prompt" projektNummer
    if check_existing_project $projektNummer; then
        echo "Cant create. Project already exists"
        exit 1
    fi
    read -p "$projekt_details_kunde" projektKunde
    read -p "$projekt_details_deadline" projektDevDeadline
    read -p "$projekt_details_deadline" projektQaDeadline
    read -p "$projekt_details_deadline" projektImpDeadline
    if [[ "$projektDevDeadline" =~ $deadline_regex || "$projektQaDeadline" =~ $deadline_regex || "$projektImpDeadline" =~ $deadline_regex ]]; then
        echo "Creating project"
        create_task_project "$projektNummer" "$projektKunde" "$projektDevDeadline" "$projektQaDeadline" "$projektImpDeadline"
    else
        echo "Wrong deadline format, exiting.."
        exit 1
    fi
}

# Variables
CC_HERSTELLUNG=1
BUG_FEATURE_TO_CC=2
KOMMENDE_DEADLINES=3
UNERLEDIGTES_CC=4

projekt_nummer_prompt="Projektnummer: "
projekt_details_kunde="Kunde: "
projekt_details_deadline="Deadline (Y-M-D): "

deadline_regex='^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$'

unresolved_from_cc() {
    read -p "$projekt_nummer_prompt" projektNummer
    if check_existing_project $projektNummer; then
        task list project:"$projectNummer" +bug or +feature
    else
        echo "Project doesnt exist, exiting"
        exit 1
    fi
}

add_bug_or_feature() {
    read -p "$projekt_nummer_prompt" projektNummer
    if check_existing_project $projektNummer; then
        read -p "Description: " description
        read -p "Type1 for bug, 2 for cc_feature: " type
        echo $type
        if [[ $type -eq 1 ]]; then
            task add "$description" project:"$projectNummer" +bug
        elif [[ $type -eq 2 ]]; then
            task add "$description" project:"$projectNummer" +feature
        else
            echo "Wrong buddy, exiting"
            exit 1
        fi
    else
        echo "Project doesnt exist, exiting"
        exit 1
    fi
}

show_deadlines() {
    # Obtain all ccs
    # For each one obtain its info
    # For each one show
    # CC:
    # - Dev Delivery Date: Date (time left)
    # - QA Delivery Date: Date (time left)
    # - Imp Delivery Date: Date (time left)
    actual_date=$(date +%s)
    for id in $(task _ids +cc); do
        # Use 'info' to get details for each task
        # Obtain whole info
        # Grep for Description and save into a variable
        # Grep for dev_deli_date, compute difference in time
        # Grep for qa_deli_date, compute difference in time
        # Grep for imp_deli_date, compute...
        desc=$(task "$id" info | grep ^Description)

        ddd=$(task "$id" info | grep ^dev_deli | awk '{print $2}')
        dev_due_date=$(date -d "$ddd" +%s)
        dev_diff_sec=$((dev_due_date - actual_date))
        dev_days=$((dev_diff_sec / 86400))          # 86400 seconds in a day
        dev_hours=$(( (dev_diff_sec % 86400) / 3600 ))
        dev_minutes=$(( (dev_diff_sec % 3600) / 60 ))

        qdd=$(task "$id" info | grep ^qa_deli  | awk '{print $2}')
        qa_due_date=$(date -d "$qdd" +%s)
        qa_diff_sec=$((qa_due_date - actual_date))
        qa_days=$((qa_diff_sec / 86400))          # 86400 seconds in a day
        qa_hours=$(( (qa_diff_sec % 86400) / 3600 ))
        qa_minutes=$(( (qa_diff_sec % 3600) / 60 ))

        idd=$(task "$id" info | grep ^imp_deli | awk '{print $2}')
        imp_due_date=$(date -d "$idd" +%s)
        imp_diff_sec=$((imp_due_date - actual_date))
        imp_days=$((imp_diff_sec / 86400))          # 86400 seconds in a day
        imp_hours=$(( (imp_diff_sec % 86400) / 3600 ))
        imp_minutes=$(( (imp_diff_sec % 3600) / 60 ))

        echo "ID: $id
              Desc $desc
              Dev due date: $ddd
              - Time remaining: $dev_days days, $dev_hours hours, $dev_minutes minutes
              QA  due date: $qdd, 
              - Time remaining: $qa_days days, $qa_hours hours, $qa_minutes minutes
              Imp due date: $idd,
              - Time remaining: $imp_days days, $imp_hours hours, $imp_minutes minutes
        "
    done
}


if [[ "$auswahl" -eq CC_HERSTELLUNG ]]; then
    create_project
elif [[ "$auswahl" -eq BUG_FEATURE_TO_CC ]]; then 
    add_bug_or_feature
elif [[ "$auswahl" -eq KOMMENDE_DEADLINES ]]; then 
    show_deadlines
elif [[ "$auswahl" -eq UNERLEDIGTES_CC ]]; then 
    unresolved_from_cc
else
    echo "tschuess"
fi
