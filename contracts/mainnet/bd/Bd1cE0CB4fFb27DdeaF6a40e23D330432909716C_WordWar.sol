contract WordWar{struct T{address o;bytes1[9] l;uint n;}T[9] public t;uint k;
function m(){if(k<9){t[k].o=msg.sender;k++;}}
function s(uint i,address r){if(t[i].o==msg.sender){t[i].o=r;}}
function w(uint i,bytes1 c){if(t[(t[i].n+i)%9].o==msg.sender){t[i].l[t[i].n]=c;t[i].n++;}}}