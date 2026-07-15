# Thamdee Ecosystem — Brand, Design & Development Guide

เอกสารอ้างอิงฉบับเต็มสำหรับเว็บไซต์หลัก thamdee.com ครอบคลุมกลยุทธ์แบรนด์ โครงสร้างเว็บไซต์ ระบบดีไซน์ SEO และแผนพัฒนาต่อ ใช้คู่กับโค้ดใน repository นี้

---

## 1. Executive Summary

thamdee.com ทำหน้าที่เป็น **Brand Gateway** ของ Thamdee Ecosystem — หน้าเดียวที่ตอบ 3 คำถามภายใน 10 วินาทีแรก: Thamdee คือใคร (ระบบนิเวศการเรียนรู้ เทคโนโลยี และคอนเทนต์) มีอะไรบ้าง (9 โปรเจกต์) และฉันควรไปต่อที่ไหน (CTA ชัดเจนสู่ subdomain แต่ละตัว) สถาปัตยกรรมเป็น one-page landing + หน้าเอกสารความน่าเชื่อถือ 3 หน้า สร้างด้วย Hugo เพื่อความเร็ว SEO และค่าดูแลเป็นศูนย์ ข้อมูลโปรเจกต์และข้อความทั้งหมดแยกเป็นไฟล์ YAML เพื่อรองรับการเติบโต (เพิ่มโปรเจกต์ = เพิ่ม 10 บรรทัดใน YAML)

## 2. Brand Strategy

**Brand Essence:** ทำสิ่งดี ให้เกิดประโยชน์จริง (Good, made useful)

**Mission:** พัฒนาแอป ความรู้ และคอนเทนต์ที่เชื่อถือได้และเข้าถึงง่าย เพื่อยกระดับการเรียนรู้ วิชาชีพ และคุณภาพชีวิตของคนไทยและสังคมโลก

**Vision:** เป็นระบบนิเวศการเรียนรู้ดิจิทัลที่คนการศึกษาและประชาชนทั่วไปวางใจเลือกใช้เป็นอันดับแรก

**Positioning Statement:** สำหรับครู ผู้บริหาร ผู้เรียน และประชาชนที่ต้องการใช้เทคโนโลยีและความรู้อย่างมั่นใจ Thamdee คือระบบนิเวศเดียวที่รวมแอป ศูนย์ความรู้ และคอนเทนต์ที่ตรวจทานแล้วไว้ด้วยกัน ต่างจากแหล่งความรู้กระจัดกระจายทั่วไป ตรงที่ทุกชิ้นงานยึดมาตรฐานเดียวกัน คือ ถูกต้อง ใช้ง่าย และเป็นประโยชน์จริง

**Tagline ภาษาไทย (5 ตัวเลือก):**
1. ทำสิ่งดี ให้เกิดประโยชน์จริง ← *ใช้บนเว็บ*
2. เรียนรู้ เทคโนโลยี และสิ่งดี ๆ ในที่เดียว
3. ความรู้ที่ใช้ได้จริง เทคโนโลยีที่ใช้ง่ายจริง
4. ระบบนิเวศแห่งการเรียนรู้เพื่อทุกคน
5. เพราะสิ่งดี ๆ ควรเข้าถึงได้ทุกคน

**Tagline ภาษาอังกฤษ (5 ตัวเลือก):**
1. Good things, made truly useful. ← *ใช้บนเว็บ*
2. Learning, technology, and good — in one place.
3. Knowledge you can trust. Tools you can use.
4. An ecosystem for lifelong learners.
5. Technology for good, learning for all.

**Value Proposition หลัก:** ที่เดียวที่รวมแอปใช้งานจริง ศูนย์ความรู้เฉพาะทางสำหรับคนการศึกษา และคอนเทนต์ AI/เทคโนโลยีที่ตรวจทานแล้ว — ฟรี เข้าถึงง่าย เหมาะกับทุกวัย

**Key Message หน้าแรก:** "Thamdee รวมแอป ศูนย์ความรู้ และคอนเทนต์ที่เชื่อถือได้ไว้ในที่เดียว เพื่อทุกคนที่อยากใช้เทคโนโลยีอย่างมั่นใจและมีคุณค่า"

## 3. Information Architecture

```
Header (sticky): โลโก้ | หน้าแรก · Ecosystem · แอป · ศูนย์ความรู้ · คอนเทนต์ · เกี่ยวกับ · ติดต่อ | [สำรวจ Ecosystem]

1. Hero            — headline + sub + CTA คู่ + Orbit diagram (signature)
2. About           — "ทำสิ่งดี ให้เกิดประโยชน์จริง" + 4 เสาหลัก
3. Ecosystem       — การ์ด 9 โปรเจกต์ (data-driven) + chip หมวด + audience
4. Apps            — จุดเด่นแอป + 3 checkpoints + disclaimer สุขภาพ + CTA
5. Knowledge Hubs  — การ์ดศูนย์ความรู้ (hub/teacher/gced/admin/tblf/law)
6. Content         — YouTube · TikTok · Hub (เลือกตามสไตล์การเรียนรู้)
7. Why Thamdee     — 3 เหตุผลความน่าเชื่อถือ (พื้นเขียวเข้ม)
8. Founder         — ผู้จัดทำ: ประวัติย่อ เส้นทางงานการศึกษา ที่มาของ Thamdee + คำขอบคุณแหล่งอ้างอิง
9. Follow          — ปุ่มติดตาม 3 ช่องทาง (รอ newsletter ในอนาคต)
10. Contact        — อีเมล + แนวทางแจ้งข้อผิดพลาด

Footer: about + tagline | ลิงก์ 9 โปรเจกต์ | ลิงก์กฎหมาย | โซเชียล | copyright + AI note
หน้าแยก: /privacy/ · /terms/ · /disclaimer/ · 404
```

หลักการลดความสับสนหลัก/ย่อย: ทุกลิงก์ออกไป subdomain ใช้ URL เต็มและระบุชื่อโปรเจกต์ใน link text; เว็บหลักไม่มีเนื้อหาเชิงลึกซ้ำกับเว็บย่อย ทำหน้าที่ "ชี้ทาง" เท่านั้น

## 4. Visual Design System

ดู token จริงได้ที่ `assets/css/main.css` (`:root`)

| Token | ค่า | ใช้กับ |
|---|---|---|
| เขียวสน `--green-700` | `#17614F` | สีหลัก ปุ่ม primary โลโก้ |
| เขียวเข้ม `--green-800` | `#114A3C` | hover |
| เขียวสด `--green-600` | `#1D7A63` | eyebrow ลิงก์เน้น |
| เขียวอ่อน `--green-100` | `#E2EFE8` | พื้นไอคอน chip |
| ทองดาวเรือง `--gold` | `#E8A13D` | accent กราฟิก focus ring |
| พื้นหลัก `--bg` | `#FCFCF9` | พื้นหน้าเว็บ (ขาวอุ่น) |
| พื้นสลับ `--alt` | `#EFF5F0` | section สลับ |
| เขียวลึก `--deep` | `#123F34` | section Why + footer |
| ตัวอักษร `--ink` | `#22302B` | ข้อความหลัก |

เหตุผลการเลือกสี: เขียวสนสื่อความน่าเชื่อถือ การเติบโต และ "ความดี" โดยไม่ซ้ำกับสีสถาบันการศึกษา/ธนาคารทั่วไป ทองดาวเรืองให้ความอบอุ่นแบบไทยโดยไม่หวานเกิน — ใช้เป็น accent กราฟิกเท่านั้น (ไม่ใช้เป็นสีตัวอักษรบนพื้นขาวเพราะ contrast ไม่ผ่าน)

**Typography:** หัวข้อ **Prompt** (ไม่มีหัว ทันสมัย น้ำหนัก 500–700) / เนื้อหา **IBM Plex Sans Thai Looped** (มีหัว อ่านง่ายสำหรับผู้สูงวัยและการอ่านยาว) ขนาดฐาน 17px, line-height 1.8 สำหรับภาษาไทย

**Signature element:** Orbit Diagram ใน Hero — โหนด 9 โปรเจกต์โคจรรอบแกน "ทำดี" สื่อคำว่า ecosystem เป็นภาพเดียว วงแหวนหมุนช้ามาก (90–150 วินาที/รอบ) และหยุดสนิทเมื่อผู้ใช้ตั้ง reduced motion

**อื่น ๆ:** การ์ด radius 18px เงาเขียวจาง / ปุ่ม pill สูง ≥48px / ไอคอน stroke 1.8px ชุดเดียวกันทั้งเว็บ / ภาพประกอบแนว geometric-minimal สีแบรนด์ (ไม่ใช้ stock photo) / motion มีเพียง 2 อย่าง: orbit หมุนช้า + reveal ตอน scroll

## 5. UX Guidelines (สรุปที่บังคับใช้ในโค้ดแล้ว)

- H1 เดียวต่อหน้า, ลำดับ heading ถูกต้อง, landmark ครบ (header/main/footer/nav)
- Skip link, focus-visible สีทองชัดเจน, ปุ่มปิดเมนูด้วย Escape
- Contrast ข้อความทุกคู่สี ≥ 4.5:1 (AA)
- Touch target ≥ 48px, ฟอนต์ฐาน 17px
- Mobile-first: grid 3→2→1, hero visual ขึ้นก่อนบนมือถือ, CTA เต็มความกว้าง
- ลิงก์การ์ดมี `visually-hidden` ระบุชื่อโปรเจกต์ เพื่อ screen reader ไม่เจอ "ดูเพิ่มเติม" ซ้ำ ๆ

## 6. SEO & Metadata (ที่ตั้งค่าแล้ว)

- **Title:** Thamdee Ecosystem — ระบบนิเวศแห่งการเรียนรู้ เทคโนโลยี และสิ่งดี ๆ
- **Description:** (ดู `hugo.toml`) ~150 ตัวอักษร มี keyword: ระบบนิเวศการเรียนรู้, แอปมือถือ, ศูนย์ความรู้ครู, ผู้บริหารสถานศึกษา, กฎหมายการศึกษา, AI เพื่อการศึกษา, GCED
- **Schema:** Organization + WebSite + ItemList (9 โปรเจกต์) ผ่าน JSON-LD
- **OG:** รูป 1200×630 ที่ `static/images/og-cover.png` (ควรแทนด้วยเวอร์ชันโลโก้จริงภายหลัง)
- **URL structure อนาคต:** เนื้อหาเชิงลึกอยู่บน subdomain ของแต่ละโปรเจกต์; เว็บหลักเพิ่มได้เฉพาะหน้า brand-level เช่น `/press/`, `/brand/`, `/apps/<app-name>/` (หน้าแนะนำ+privacy รายแอป)

## 7. Content Model

การ์ดทุกใบขับเคลื่อนด้วยข้อมูล ดู schema พร้อมคอมเมนต์ใน `data/projects.yaml` (Project Card: id/title/title_en/category/description/url/cta/status/audience) และ `data/homepage.yaml` (ทุก section) — ฟิลด์ `status: coming-soon` รองรับแล้วเชิงข้อมูล สามารถเพิ่มการแสดง badge ในเทมเพลตเมื่อเริ่มใช้จริง

## 8. เหตุผลที่เลือก Hugo (Technical Decision)

| เกณฑ์ | Hugo | Astro/Next.js | Static ล้วน |
|---|---|---|---|
| ความเร็ว build/โหลด | ดีที่สุด (ms, HTML ล้วน) | ดี แต่มี toolchain JS | ดี แต่แก้ซ้ำหลายไฟล์ |
| ดูแลโดยคนเดียว | ไบนารีเดียว ไม่มี dependency | ต้องดูแล node_modules | ง่ายแต่ scale ยาก |
| Data-driven content | YAML + templates ในตัว | ทำได้ | ทำไม่ได้ |
| SEO | HTML สมบูรณ์ + sitemap ในตัว | ทำได้ | ทำได้ |
| ต่อยอด (บทความ, สองภาษา) | รองรับในตัว (content sections, i18n) | รองรับ | ต้องรื้อ |
| ค่าใช้จ่าย | ฟรี (GitHub Pages) | ฟรี | ฟรี |

Next.js เกินความจำเป็นสำหรับเว็บที่ไม่มี interactivity ฝั่ง server; Hugo ให้ทั้งความเรียบง่ายของ static และพลัง template/i18n สำหรับอนาคต

## 9. Trust / Legal / Governance (มีแล้วในเว็บ)

หน้า Privacy (อิง PDPA, ระบุชัดว่า static site ไม่เก็บข้อมูล), Terms, Disclaimer (เนื้อหาความรู้ + แอปสุขภาพ + Responsible AI), อีเมลติดต่อ + แนวทางแจ้งข้อผิดพลาดใน section Contact, Copyright + AI note ใน footer

## 10. Roadmap

**ระยะ 1 (หลังเปิดตัว):** แทน OG image ด้วยโลโก้จริง · เพิ่ม Google Analytics/Plausible (อัปเดต Privacy พร้อมกัน) · เพิ่ม badge "Coming Soon" ในเทมเพลตการ์ด
**ระยะ 2:** section Featured Content ดึงบทความล่าสุดจาก hub (build-time ผ่าน `getJSON` หรือ RSS) · ฝังวิดีโอ YouTube ล่าสุดอัตโนมัติ · หน้าแนะนำรายแอป `/apps/<name>/` + Privacy Policy รายแอป
**ระยะ 3:** สองภาษา ไทย/อังกฤษ (Hugo i18n — โครงสร้าง data แยกไฟล์ไว้รองรับแล้ว) · Newsletter (Buttondown/Mailerlite) · ระบบค้นหา (Pagefind — เหมาะกับ static) · หน้า Press Kit / Brand Kit
**ระยะ 4:** ฐานความรู้/บทความบนเว็บหลัก (Hugo content section) · ระบบสมาชิกเมื่อจำเป็นจริง (พิจารณาย้ายบางส่วนไป platform ที่มี backend)

## 11. Checklist ก่อนเปิดตัว

- [ ] แก้ `contactEmail` ใน `hugo.toml` เป็นอีเมลจริง
- [ ] ตรวจ URL subdomain ทั้ง 9 ว่าใช้งานได้จริง (รวม tblf.thamdee.com และ law.thamdee.com) (โดยเฉพาะ youtube./tiktok. redirect)
- [ ] แทน `og-cover.png` และ favicon ด้วยโลโก้ทางการ (ถ้ามี)
- [ ] อ่านทวนหน้า Privacy/Terms/Disclaimer และปรับให้ตรงข้อเท็จจริงของหน่วยงาน
- [ ] Push ขึ้น GitHub, เปิด Pages (Source: GitHub Actions), ตั้ง DNS ตาม README
- [ ] ทดสอบบนมือถือจริง + Lighthouse (เป้า: Performance ≥ 95, Accessibility ≥ 95, SEO 100)
- [ ] ทดสอบ share ลิงก์ใน LINE/Facebook ว่า OG แสดงถูกต้อง
- [ ] Submit sitemap ที่ Google Search Console
