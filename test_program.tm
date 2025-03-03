Gokuldham 
{
    tapu_int a = 5;
    tapu_int b = 3;
    tapu_string c = "hello";
    tapu_int d = a + b;

    // This is a comment line
    
    daya_ki_maa_ne_kaha(tapu_int, a + b);
    daya_ki_maa_ne_kaha(tapu_int, a - b);
    daya_ki_maa_ne_kaha(tapu_int, a * b);
    daya_ki_maa_ne_kaha(tapu_int, a / b);
    daya_ki_maa_ne_kaha(tapu_string, c);
    daya_ki_maa_ne_kaha(tapu_int, d);

    bapuji_sahmat(a > b)
    {
        // This is inside the if block
        tapu_int e = a * b;
        daya_ki_maa_ne_kaha(tapu_int, e);
    }
    bapuji_asahmat
    {
        // This is inside the else block
        tapu_int f = a / b;
        daya_ki_maa_ne_kaha(tapu_int, f);
    }
}

