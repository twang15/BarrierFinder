
;; Function foo (foo, funcdef_no=0, decl_uid=1389, symbol_order=0)

foo ()
{
  int b;
  int a;

  <D.1394>:
  a = a + b;
  if (a == 1) goto <D.1396>; else goto <D.1397>;
  <D.1396>:
  if (b == 2) goto <D.1398>; else goto <D.1399>;
  <D.1398>:
  b = 1;
  <D.1399>:
  goto <D.1393>;
  <D.1397>:
  goto <D.1394>;
  <D.1393>:
  b = b + 1;
  return;
}


