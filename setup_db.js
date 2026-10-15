const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'azkar_db',
  password: 'root', // تأكد من كلمة السر الخاصة بك
  port: 5432,
});

const setup = async () => {
  try {
    console.log('--- بدء تهيئة قاعدة البيانات الشاملة ---');

    await pool.query('DROP TABLE IF EXISTS dhikrs CASCADE');
    await pool.query('DROP TABLE IF EXISTS categories CASCADE');

    await pool.query(`
      CREATE TABLE categories (
        id SERIAL PRIMARY KEY,
        name VARCHAR(100) UNIQUE NOT NULL
      );
      CREATE TABLE dhikrs (
        id SERIAL PRIMARY KEY,
        category_id INTEGER REFERENCES categories(id) ON DELETE CASCADE,
        content TEXT NOT NULL,
        fadl TEXT,
        target_count INTEGER DEFAULT 1
      );
    `);

    const categories = [
      'أذكار الصباح', 'أذكار المساء', 'أذكار بعد الصلاة',
      'أذكار النوم', 'أذكار الاستيقاظ', 'أذكار السفر',
      'أذكار المسجد', 'أدعية نبوية'
    ];

    for (const name of categories) {
      await pool.query('INSERT INTO categories (name) VALUES ($1)', [name]);
    }

    const azkarData = [
      // أذكار الصباح (1)
      [1, 'أصبحنا وأصبح الملك لله والحمد لله، لا إله إلا الله وحده لا شريك له', null, 1],
      [1, 'اللهم أنت ربي لا إله إلا أنت، خلقتني وأنا عبدك، وأنا على عهدك ووعدك ما استطعت...', 'سيد الاستغفار', 1],
      [1, 'آية الكرسي: الله لا إله إلا هو الحي القيوم...', 'من قالها حين يصبح أجير من الجن حتى يمسي', 1],
      [1, 'بسم الله الذي لا يضر مع اسمه شيء في الأرض ولا في السماء وهو السميع العليم', 'لم يضره شيء', 3],
      [1, 'سبحان الله وبحمده', 'حطت خطاياه وإن كانت مثل زبد البحر', 100],

      // أذكار المساء (2)
      [2, 'أمسينا وأمسى الملك لله والحمد لله', null, 1],
      [2, 'أعوذ بكلمات الله التامات من شر ما خلق', 'حماية من الهوام', 3],
      [2, 'اللهم بك أمسينا، وبك أصبحنا، وبك نحيا، وبك نموت، وإليك المصير', null, 1],

      // بعد الصلاة (3)
      [3, 'أستغفر الله', null, 3],
      [3, 'اللهم أنت السلام ومنك السلام، تباركت يا ذا الجلال والإكرام', null, 1],
      [3, 'سبحان الله', null, 33],
      [3, 'الحمد لله', null, 33],
      [3, 'الله أكبر', null, 33],

      // السفر (6)
      [6, 'الله أكبر، الله أكبر، الله أكبر، سبحان الذي سخر لنا هذا وما كنا له مقرنين', 'دعاء الركوب', 1],
      [6, 'اللهم إنا نسألك في سفرنا هذا البر والتقوى', 'دعاء السفر', 1]
    ];

    for (const d of azkarData) {
      await pool.query('INSERT INTO dhikrs (category_id, content, fadl, target_count) VALUES ($1, $2, $3, $4)', d);
    }

    console.log('✅ تم إعداد قاعدة البيانات بنجاح وبشكل كامل!');
    process.exit();
  } catch (err) {
    console.error('❌ حدث خطأ أثناء الإعداد:', err);
    process.exit(1);
  }
};

setup();
