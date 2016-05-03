#!/usr/bin/perl

open(ENTREE,"<",$ARGV[0]);
open(SORTIE,">",$ARGV[1]);

#######################################
## PARTIE LEMMATISATION              ##
#######################################
open(FILELEM,"<","lemmatiseur.dic");

my %motLem;

#index de documents:
my $cpt = 0;
my $ligne;
while($ligne=<FILELEM>){
  #print $ligne." \n";
  if($ligne=~/^(\p{L}+),(\p{L}+)/)
  {
      print $1." - ".$2."\n";
      $motLem{$1} = $2;
   }
   elsif($ligne=~/^(\p{L}+)./)
   {
     print $1." ----- ".$1."\n";
     $motLem{$1} = $1;
   }
}


#######################################
## PARTIE INDEXATION ET TOKENIZER    ##
#######################################
my %docs;
my %mots;
my $id;

while($ligne=<ENTREE>){
	if($ligne=~/^\.I\s([0-9]+)/){		#parcours des lignes
		$id=$1;
	} else {
		while($ligne=~s/(\w+)//) {		#parcours des mots
			if (exists $motLem{lc $1}) {
				$docs{$motLem{lc $1}}{$id}++;			#nombre de fois où le mot apparait dans le document $id
				$mots{$motLem{lc $1}}++;				#nombre de fois où le mot apparait
			} else {
				$docs{lc $1}{$id}++;			#nombre de fois où le mot apparait dans le document $id
				$mots{lc $1}++;				#nombre de fois où le mot apparait
			}


		}
	}
}

my @tabtri = sort { $mots{$a} <=> $mots{$b} } keys(%mots);

#indexation
foreach my $mot (sort keys(%docs)) {
   	print(SORTIE "$mot");
	foreach my $id (keys %{$docs{$mot}}) {
		print(SORTIE "\t($id:$docs{$mot}{$id})");
	}
	print(SORTIE "\n");
}
