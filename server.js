const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'azkar_db',
  password: 'root', // تأكد من مطابقة كلمة السر
  port: 5432,
});

app.get('/api/azkar', async (req, res) => {
  try {
    const categoriesResult = await pool.query('SELECT * FROM categories ORDER BY id');
    const dhikrsResult = await pool.query('SELECT * FROM dhikrs');

    const response = categoriesResult.rows.map(cat => ({
      name: cat.name,
      dhikrs: dhikrsResult.rows
        .filter(d => d.category_id === cat.id)
        .map(d => ({
          id: d.id.toString(),
          text: d.content,
          fadl: d.fadl,
          targetCount: d.target_count
        }))
    }));

    res.json(response);
    console.log(`تم إرسال ${response.length} تصنيفات بنجاح.`);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

const PORT = 3000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 السيرفر يعمل على الرابط: http://localhost:${PORT}`);
});
