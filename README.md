# Thamdee Ecosystem — เว็บไซต์หลัก (thamdee.com)

Landing Page หลักของ Thamdee Ecosystem สร้างด้วย [Hugo](https://gohugo.io) แบบไม่ใช้ธีมภายนอก (custom layouts ทั้งหมด) พร้อม deploy อัตโนมัติขึ้น GitHub Pages

**สแต็ก:** Hugo (extended) v0.163.3 · HTML/CSS/JS ล้วน ไม่มี framework · GitHub Actions → GitHub Pages

## โครงสร้างโปรเจกต์

```
├── hugo.toml                 # ค่าคอนฟิกหลัก เมนู อีเมลติดต่อ ลิงก์โซเชียล
├── content/
│   ├── _index.md             # metadata หน้าแรก
│   ├── privacy.md            # นโยบายความเป็นส่วนตัว (PDPA)
│   ├── terms.md               # ข้อกำหนดการใช้งาน
│   └── disclaimer.md          # ข้อจำกัดความรับผิดชอบ + Responsible AI
├── data/
│   ├── projects.yaml          # ★ โปรเจกต์ทั้ง 8 (เพิ่ม/แก้โปรเจกต์ที่นี่)
│   └── homepage.yaml          # ★ ข้อความทุก section ของหน้าแรก
├── layouts/
│   ├── baseof.html            # โครง HTML หลัก
│   ├── home.html              # หน้าแรก (อ่านข้อมูลจาก data/)
│   ├── page.html              # เทมเพลตหน้าเอกสาร/กฎหมาย
│   ├── 404.html
│   └── partials/              # head (SEO/schema), header, footer, icon, orbit, logo
├── assets/
│   ├── css/main.css           # Design system + ทุกสไตล์ (มี design tokens ด้านบนไฟล์)
│   └── js/main.js             # เมนูมือถือ + scroll reveal (~1 KB)
├── static/                    # favicon, robots.txt, CNAME, รูป OG
├── docs/BRAND-DESIGN-GUIDE.md # คู่มือแบรนด์ ดีไซน์ SEO และ roadmap ฉบับเต็ม
└── .github/workflows/deploy.yml
```

## การแก้ไขที่พบบ่อย (ไม่ต้องแตะโค้ด)

| ต้องการ | แก้ที่ไฟล์ |
|---|---|
| แก้ข้อความหน้าแรกทุก section (รวมส่วนผู้จัดทำ) | `data/homepage.yaml` |
| เพิ่ม/แก้/ปิดโปรเจกต์ในเครือ | `data/projects.yaml` (การ์ดสร้างอัตโนมัติ) |
| แก้เมนู อีเมล ลิงก์ YouTube/TikTok | `hugo.toml` |
| แก้หน้า Privacy/Terms/Disclaimer | `content/*.md` |
| ปรับสี ฟอนต์ ระยะห่าง | ตัวแปร `:root` บนสุดของ `assets/css/main.css` |

การเพิ่มโปรเจกต์ใหม่: คัดลอกบล็อกหนึ่งใน `projects.yaml` แล้วแก้ค่า — ใส่ `status: coming-soon` ได้หากยังไม่เปิดตัว และเพิ่มไอคอนใหม่ใน `layouts/partials/icon.html` โดยใช้ `id` เดียวกัน

## รันบนเครื่อง

```bash
# ติดตั้ง Hugo extended v0.146 ขึ้นไป (แนะนำ 0.163.3 ให้ตรงกับ CI)
hugo server -D        # เปิด http://localhost:1313
hugo --gc --minify    # build จริงลงโฟลเดอร์ public/
```

## นำขึ้น GitHub + เปิดใช้โดเมน thamdee.com

1. สร้าง repository ใหม่ (เช่น `thamdee-site`) แล้ว push โค้ดทั้งหมดขึ้น branch `main`

   ```bash
   git init && git add . && git commit -m "Thamdee landing page v1"
   git branch -M main
   git remote add origin https://github.com/<username>/thamdee-site.git
   git push -u origin main
   ```

2. ใน GitHub ไปที่ **Settings → Pages → Build and deployment → Source** เลือก **GitHub Actions** — workflow ใน `.github/workflows/deploy.yml` จะ build และ deploy ให้อัตโนมัติทุกครั้งที่ push

3. ตั้งค่าโดเมน: **Settings → Pages → Custom domain** ใส่ `thamdee.com` (ไฟล์ `static/CNAME` เตรียมไว้แล้ว) แล้วตั้ง DNS ที่ผู้ให้บริการโดเมน:

   | Type | Name | Value |
   |---|---|---|
   | A | @ | 185.199.108.153 |
   | A | @ | 185.199.109.153 |
   | A | @ | 185.199.110.153 |
   | A | @ | 185.199.111.153 |
   | CNAME | www | `<username>.github.io` |

4. รอ DNS อัปเดตแล้วติ๊ก **Enforce HTTPS**

5. **Subdomain ของโปรเจกต์ย่อย** (`app.` `hub.` `teacher.` `gced.` `admin.` `law.` `youtube.` `tiktok.`): แต่ละตัวเพิ่ม CNAME record ชี้ไปยังปลายทางของโปรเจกต์นั้น เช่น repo GitHub Pages แยกของแต่ละเว็บ หรือใช้ redirect (เช่น `youtube.thamdee.com` → redirect ไปหน้า YouTube channel ผ่านบริการ redirect ของ DNS/Cloudflare)

## คุณภาพที่ built-in มาแล้ว

- **SEO:** title/description, canonical, Open Graph + รูป 1200×630, JSON-LD (Organization + WebSite + ItemList 8 โปรเจกต์), sitemap.xml, robots.txt
- **Accessibility:** skip link, semantic headings (H1 เดียว), focus ring ชัดเจน, ปุ่มขนาด ≥48px, contrast ผ่าน WCAG AA, เมนูมือถือใช้ aria-expanded + ปิดด้วย Escape, รองรับ `prefers-reduced-motion`
- **Performance:** ไม่มี framework, JS ~1 KB, CSS ไฟล์เดียว minify + fingerprint, ฟอนต์ `display=swap`
- **ความน่าเชื่อถือ:** หน้า Privacy (PDPA), Terms, Disclaimer + Responsible AI note ใน footer

## เอกสารเพิ่มเติม

กลยุทธ์แบรนด์ (tagline ทางเลือก, positioning), Design System ฉบับเต็ม, แนวทาง SEO, Content Model, Roadmap และ Checklist ก่อนเปิดตัว อยู่ที่ [`docs/BRAND-DESIGN-GUIDE.md`](docs/BRAND-DESIGN-GUIDE.md)

---

© Thamdee — ทำสิ่งดี ให้เกิดประโยชน์จริง
# thamdee-site
