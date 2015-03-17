BEGIN {
   False=0
   True=!False
   i=0
   inGasPriceRecord=False
   expectName=False
}

/<tr id="rrlow_[0-9]+"/ {
   # print "BOR",i
   # print $0
   inGasPriceRecord=True
   ai[i]=0
}

inGasPriceRecord && /<div class="sp_p">/ {
   sub("<div class=\"pd\">","<div class=\"p.\">")
   gsub("\"></div><div class=\"p","")
   sub("^.*<div class=\"sp_p\"><div class=\"p","")
   sub("\"></div></div>.*$","")
   # print
   price[i]=$0
}

inGasPriceRecord && /<dd>/ {
   sub("^[ ]*<dd>","")
   sub("</dd>[ ]*$","")
   sub("&amp;","\\&")
   address[i,ai[i]]=$0
   # print "address["ai[i]"]="address[i,ai[i]]
   ai[i]++
}

inGasPriceRecord && /<dt>/ {
   expectName=True
}

inGasPriceRecord && expectName && /<a href="/ {
   gsub("<img src=\"http://mymarathonstation.com/.*.png\" border=\"\" alt=\"\" />","Marathon")
   gsub("<img src=\"http://duchessshoppe.*.com/.*.png\" border=\"\" alt=\"\" />","Duchess")
   gsub("<img src=\"http://thorntons.*.com/.*.png\" border=\"\" alt=\"\" />","Thorntons")
   gsub("<img src=\"/images/brands/199_p.png\" border=\"\" alt=\"\" />","Thorntons")
   gsub("<img src=\"http://mycertifiedoil.com/images/249/price-listing-ad-brand-logo.png\" border=\"\" alt=\"\" />","Certified")
   expectName=False
   sub("</a>[ ]*$","")
   sub("^.*>","")
   sub("&amp;","\\&")
   name[i]=$0
   # print
}

inGasPriceRecord && / class="p_area">/ {
   sub("^.* class=\"p_area\">","")
   sub("</a>[ ]*$","")
   area[i]=$0
   # print
}

inGasPriceRecord && /<a href="\/Profile[.]aspx[?]member=/ {
   sub("^.*<a href=\"/Profile[.]aspx[?]member=","")
   sub("\".*$","")
   reporter[i]=$0
   # print
}

inGasPriceRecord && expectRelativeTime {
   expectRelativeTime=False
   sub("^[ ]*","")
   sub("[ ]ago[ ]*$","")
   timeAgo[i]=$0
   # print
}

inGasPriceRecord && /<div class="tm" / {
   sub("^[ ]*<div class=\"tm\" title=\"","")
   sub("\">[ ]*$","")
   time[i]=$0
   expectRelativeTime=True
   # print
}

inGasPriceRecord && /<\/tr>/ {
   i ++
   # print "EOR"
   # print $0
   inGasPriceRecord=False
}

END {
   for (j=0;j<i && True;j++) {
      if (False) {
         print j
         print price[j]
         print name[j]
         print address[j,0]
         print area[j]
         print reporter[j]
         print time[j]
         print timeAgo[j]
      }

      delimiter="\t"
      print price[j] delimiter name[j] delimiter address[j,0] delimiter area[j] delimiter reporter[j] delimiter time[j] delimiter timeAgo[j]
   }
}
