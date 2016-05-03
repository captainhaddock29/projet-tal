#!/usr/bin/perl

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

print "size of hash:  " . keys( %motLem ) . ".\n";
