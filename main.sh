#!/bin/bash
echo "----- Bienvenue au jeux de mots -----"
declare -a ListeCharacter
i=0
Nbr_vie=10
true=0
Result_word=0
function getHiddenWord {
	while read LINE
	do
		T[i]=$LINE
		i=`expr $i + 1`
	done < listWords.txt
	Hidden_word=$RANDOM

	while [ $Hidden_word -ge $i ]
	do
		Hidden_word=$RANDOM
	done
	a=0
	while [ $a -lt ${#T[${Hidden_word}]} ]
	do
		ListCharacter[$a]=0
		a=`expr $a + 1`
	done
}

function FindLetter
{
	j=0
	true=0
	r=0
	Result_word=0
	char=$c
	if [ ${#c} -eq "1" ] # si la taille ed ce caractere est egale a 1
	then
		c=`echo $c`
		while [ $j -lt ${#T[${Hidden_word}]} ] # tant que j est infereur a la taille du tableau
		do
			if [ "$c" == "${T[${Hidden_word}]:$j:1}" ] # si ce caractere se trouve dans cette position dans le mot cache
			then
				ListCharacter[${j}]=1 #caractere trouve
				true=1 # c'est correct
			fi
			j=`expr $j + 1`
		done
	fi
    while [ ! $r == ${#T[${Hidden_word}]} ] # tant que r est different a la taille du tableau
	do
		Result_word=`expr $Result_word + ${ListCharacter[r]}` # mise a jour de resultat trouve
		r=`expr $r + 1`
	done
}

function DisplayWord {
	echo -ne "Deviner le mot: "
	t=0
	while [ ! $t == ${#T[${Hidden_word}]} ] # tant que t est different de la taille du tableau
	do
			if [ ${ListCharacter[${t}]} == "1" ] # si le caractere se trouve dant le mot
			then
				echo -n "${T[${Hidden_word}]:$t:1}" # on remplace le < - > par le caractere dans cette position
			else
				echo -n "-"
			fi
			t=`expr $t + 1`
	done
	echo -e "\n"
}

function WinTest {
if [ "${Result_word}" == "${#T[${Hidden_word}]}" ] #si le mot trouve est egale au mot cache
then
	echo "Vous avez devinez le mot: ${T[$Hidden_word]}"
    echo "Bravo tu a gagner :D"
fi
}

function LoseTest {
if [ $Nbr_vie == "0" ] #si le nombre de tentative est epuise
then
    echo "Vous avez perdu!"
    echo "Vous n'avez pas devinez le mot: ${T[$Hidden_word]}"
fi
}
Nbr_vie=10
true=0
ListCharacter=0
getHiddenWord;
a=0

while [[ ! "${Result_word}" == "${#T[${Hidden_word}]}" && ! "$Nbr_vie" == "0" ]]
# tant que le mot trouve est different de mot cache et le nombre de vie est different de 0
do
	DisplayWord; #affichage du mot (au debut il sera sous forme de tiret)
    echo -n "Entrer le caractere: "
	read c
	FindLetter; #on demande de saisir un caractere et on cherche s'il existe ou pas dans le mot cache
	if [ $true == "0" ] #si le caractere saisie ne se trouve pas dans le mot cache
	then
		echo "incorrect"
		Nbr_vie=$((Nbr_vie-1)) #decrementation de nbr de vie
		echo "Tentative restant: $Nbr_vie"
	else
		echo "correct"
	fi
done
    	WinTest;
	LoseTest;
exit 0
#fin du programme
