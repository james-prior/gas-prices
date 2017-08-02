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

inGasPriceRecord && /<div class="price_num"[^>]*>/ {
   sub("^.*<div class="price_num"[^>]*>","")
   sub("</div>.*$","")
   # print
   price[i]=$0
}

inGasPriceRecord && /<dd>/ {
   sub("^[ ]*<dd>","")
   sub("</dd>[ ]*$","")
   sub("&amp;","\\&")
   address[i,ai[i]]=$0
   sub("^[ ]*","",address[i,ai[i]])
   # print "address["ai[i]"]="address[i,ai[i]]
   ai[i]++
}

inGasPriceRecord && /<dt>/ {
   expectName=True
}

inGasPriceRecord && expectName && / <a href="/ {
   gsub("<img src=\"http://mymarathonapp.com/images/213/price-listing-ad-brand-logo.png\" border=\"\" alt=\"\" />","Marathon")
   gsub("<img src=\"http://duchessshoppe.*.com/.*.png\" border=\"\" alt=\"\" />","BP")
   gsub("<img src=\"http://thorntons.*.com/.*.png\" border=\"\" alt=\"\" />","Thorntons")
   gsub("<img src=\"/images/brands/199_p.png\" border=\"\" alt=\"\" />","Thorntons")
   gsub("<img src=\"http://mycertifiedoil.com/images/249/price-listing-ad-brand-logo.png\" border=\"\" alt=\"\" />","Certified")
   gsub("<img src=\"http://bellstores.com/images/253/price-listing-ad-brand-logo.png\" border=\"\" alt=\"\" />","Marathon")
   gsub("<img src=\"http://udfstores.com/images/1360/price-listing-ad-brand-logo.png\" border=\"\" alt=\"\" />","UDF")
   expectName=False
   sub("</a>[ ]*$","")
   sub("^.*>","")
   sub("&amp;","\\&")
   # print "name", i, name[i], $0
   name[i]=$0
   # print
}

inGasPriceRecord && / class="p_area">/ {
   # print "area", i, name[i], $0
   sub("^.* class=\"p_area\">","")
   sub("</a>[ ]*$","")
   area[i]=$0
   # print
}

inGasPriceRecord && /<a href="\/Profile[.]aspx[?]member=/ {
   sub("^.*<a href=\"/Profile[.]aspx[?]member=","")
   sub("\".*title=\"",",")
   sub("\"> ",",")
   sub("<.*$","")
   split($0,foo,",")
   reporter[i]=foo[1]
   time[i]=foo[2]
   timeAgo[i]=foo[3]
   # print
}

inGasPriceRecord && /<tr>/ {
   inGasPriceRecord += 1
}

inGasPriceRecord && /<\/tr>/ {
   inGasPriceRecord -= 1
   if (!inGasPriceRecord) {
      i ++
      # print "EOR"
      # print $0
      inGasPriceRecord=False
   }
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
