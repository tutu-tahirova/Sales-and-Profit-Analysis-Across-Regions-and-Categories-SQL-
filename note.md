# Superstore Satış və Mənfəət Analizi (SQL və Python)

## 1. Layihəyə Baxış və Metodologiya
Bu layihə "Superstore" pərakəndə satış dataseti üzərində mənfəət və satış analizi həyata keçirir.
- Bütün əsas hesablamalar, aqreqasiyalar, pəncərə funksiyaları və qruplaşdırmalar **SQLite** vasitəsilə birbaşa SQL-də icra olunub.
- **Python** və daxilində **Pandas** yalnız sorğuların nəticələrini DataFrame-lərə çəkmək və bonus yoxlamaları aparmaq üçün istifadə edilib.
- **Vizualizasiya:** Əsas biznes nəticələri **Matplotlib** və **Seaborn** vasitəsilə qrafiklərə köçürülüb.
## Business Insights:
1. Endirim Siyasətinin Tənzimlənməsi (Query Q7)
Insight: Yüksək endirimlər şirkətin mənfəətini kəskin şəkildə azaldır. Q7 analizindən görünür ki, 41% və daha çox endirim tətbiq edilən sifətlərdə orta mənfəət mənfidir. Buna qarşılıq olaraq, endirimsiz (0%) və ya aşağı endirimli (1-20%) qruplarda orta mənfəət müsbətdir.
Tövsiyə: Bütün məhsul kateqoriyaları üzrə maksimum endirim limiti (məsələn, 20-30%-dən çox olmamaqla) təyin edilməlidir.

2. Zərər Edən Sub-Kateqoriyaların Optimizasiyası (Query Q6 və Q9)
Insight: Bəzi sub-kateqoriyalar ümumi gəlirə töhfə versə də, ümumi nəticədə şirkətə zərər gətirir. Q6 və Q9 nəticələrinə əsasən, xüsusilə Tables, Bookcases və Supplies sub-kateqoriyaları mənfi ümumi mənfəətə malikdir.
Tövsiyə: Bu sub-kateqoriyalardakı qiymət siyasəti yenidən nəzərdən keçirilməli və ya bu tip məhsulların satış həcmi məhdudlaşdırılmalıdır.

3. VIP Müştəri Strategiyası (Query Q10)
Insight: Q10 analizi göstərir ki, top 10 müştəri ümumi ömürlük mənfəətin (lifetime profit) böyük bir hissəsini təmin edir və onların orta sifariş dəyəri ümumi orta göstəricidən xeyli yüksəkdir.
Tövsiyə: Bu VIP müştərilər üçün xüsusi fərdi endirim şərtləri yaradılmalıdır.

4. İllər Üzrə Satış Dinamikası (Query Q8)
Insight: Şirkətin ümumi satışı illər üzrə artım nümayiş etdirir. Q8 üzrə LAG() pəncərə funksiyasından əldə edilən rəqəmlərə görə, 2014-cü ildən 2017-ci ilə qədər ümumi satışlar illik əsasda artmış, xüsusilə 2016-2017 illəri arasında ən yüksək faiz artımı qeydə alınmışdır.
Tövsiyə: Ən güclü artımın baş verdiyi kateqoriyalar üzrə büdcə artırılmalı və həmin illərdə uğurlu olan satış strategiyaları gələcək illər üçün əsas götürülməlidir.
