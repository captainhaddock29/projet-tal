#!/usr/bin/perl


open(IDX,"<",$ARGV[0]);
open(QRY,"<",$ARGV[1]);

if ($ARGV[0] = "" || $ARGV[1]="" || $ARGV[2]="") {
    print "Les arguments suivants sont nécessaires <fichierIndexBase> <fichierIndexRequete> <ScoreMin>";
		exit 1;
}
my %doc;
my %req;
my $score;
my $normeReq;
my $normeDoc;
my $scal;
my %tabScores;

#index de documents:
while($ligne=<IDX>){
	$ligne=~s/^(\w+)//;
	$mot = $1;
	while($ligne=~s/\((\d+)\:(\d+)//) {		#parcours des mots
		    $doc{$1}{$mot}=$2;			#poids du mot $mot dans le document $1


	}
}

print "size of doc:  " . keys( %doc ) . ".\n";

#index de requetes:
while($ligne=<QRY>){
	$ligne=~s/^(\w+)//;
	$mot = $1;
	while($ligne=~s/\((\d+)\:(\d+)//) {		#parcours des mots
		    $req{$1}{$mot}=$2;			#poids du mot $mot dans le document $1
	}
}

foreach my $r (keys(%req)) {          				#prend l'indice du tableau req
	$normeReq = 0;
	foreach my $mot (keys %{$req{$r}}) {		#prend le mot du tableau doc pour chaque indice d
		$normeReq = $normeReq + ($req{$r}{$mot})*($req{$r}{$mot});
	}
	$normeReq = sqrt $normeReq;
	foreach my $d (keys(%doc)) {  				#prend l'indice du tableau doc
		$scal = 0;
		$normeDoc = 0;
		foreach my $mot (keys %{$doc{$d}}) {		#prend le mot du tableau doc pour chaque indice d
			$scal = $scal + $req{$r}{$mot}*$doc{$d}{$mot};
			$normeDoc = $normeDoc + ($doc{$d}{$mot})*($doc{$d}{$mot});
		}
		$normeDoc = sqrt $normeDoc;
		$score = $scal/($normeDoc*$normeReq);
		$tabScores{$r}{$d} = $score;
	}

}

open(OUT,">","result.REL");

foreach my $r (sort { ($a <=> $b)} keys(%tabScores)){
	foreach my $d (sort { ($tabScores{$r}{$b} <=> $tabScores{$r}{$a})} keys %{$tabScores{$r}}) {
		if($tabScores{$r}{$d} > $ARGV[2])
		{
			print OUT "$r\t$d\t0\t$tabScores{$r}{$d}\n";
		}
	}
}

#print %doc;
#print %req;
