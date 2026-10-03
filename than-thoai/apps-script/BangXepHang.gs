/**
 * Thần Thoại – nhận lực chiến từ game và ghi vào bảng xếp hạng.
 * Dán vào Tiện ích mở rộng → Apps Script của bảng tính, rồi triển khai thành Ứng dụng web.
 * Mỗi tên người chơi giữ một dòng, bảng tự sắp xếp theo lực chiến giảm dần.
 */
function doPost(e) {
  const d = JSON.parse(e.postData.contents || '{}');
  const name = String(d.name || 'Người chơi').slice(0, 40);
  const row = [new Date(), name, Number(d.cp) || 0, Number(d.ch) || 0, Number(d.lv) || 0, String(d.team || '').slice(0, 160)];

  const lock = LockService.getScriptLock();
  lock.waitLock(10000);
  try {
    const sh = SpreadsheetApp.getActive().getSheets()[0];
    const last = sh.getLastRow();
    let found = -1;
    if (last > 1) {
      const names = sh.getRange(2, 2, last - 1, 1).getValues().map(r => r[0]);
      found = names.indexOf(name);
    }
    if (found >= 0) sh.getRange(found + 2, 1, 1, row.length).setValues([row]);
    else sh.appendRow(row);
    const now = sh.getLastRow();
    if (now > 2) sh.getRange(2, 1, now - 1, row.length).sort({ column: 3, ascending: false });
  } finally {
    lock.releaseLock();
  }
  return ContentService.createTextOutput('ok');
}
