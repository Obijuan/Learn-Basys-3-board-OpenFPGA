//──────────────────────────────────────────────────────
//──  Convertir un numero bcd a ASCII
//──────────────────────────────────────────────────────
char bcd_to_ascii(int bcd)
{
    if (bcd < 10)
        return bcd + '0';
    else 
        return bcd + ('A' - 10);
}

