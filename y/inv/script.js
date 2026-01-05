// Tenants data - will be loaded from localStorage or tenants.json
let receiptsData = [];

// Load default tenants from JSON file
async function loadDefaultTenants() {
  try {
    const response = await fetch('tenants.json');
    if (response.ok) {
      const data = await response.json();
      return data.tenants || [];
    }
  } catch (error) {
    console.error('Error loading tenants.json:', error);
  }
  // Fallback to empty array if file not found
  return [];
}

const arabicOnes = [
  "",
  "واحد",
  "اثنان",
  "ثلاثة",
  "أربعة",
  "خمسة",
  "ستة",
  "سبعة",
  "ثمانية",
  "تسعة",
];
const arabicTens = [
  "",
  "عشرة",
  "عشرون",
  "ثلاثون",
  "أربعون",
  "خمسون",
  "ستون",
  "سبعون",
  "ثمانون",
  "تسعون",
];
const arabicHundreds = [
  "",
  "مائة",
  "مائتان",
  "ثلاثمائة",
  "أربعمائة",
  "خمسمائة",
  "ستمائة",
  "سبعمائة",
  "ثمانمائة",
  "تسعمائة",
];

function numberToArabicWords(num) {
  if (num === 0) return "صفر";

  let parts = [];

  let thousands = Math.floor(num / 1000);
  if (thousands > 0) {
    if (thousands === 1) parts.push("ألف");
    else if (thousands === 2) parts.push("ألفان");
    else if (thousands < 11) parts.push(arabicOnes[thousands] + " آلاف");
    else parts.push(numberToArabicWords(thousands) + " ألف");
  }

  num = num % 1000;

  let hundreds = Math.floor(num / 100);
  if (hundreds > 0) parts.push(arabicHundreds[hundreds]);

  num = num % 100;

  if (num > 0) {
    if (num < 10) {
      parts.push(arabicOnes[num]);
    } else if (num >= 10 && num < 20) {
      if (num === 10) parts.push("عشرة");
      else if (num === 11) parts.push("أحد عشر");
      else if (num === 12) parts.push("اثنا عشر");
      else parts.push(arabicOnes[num - 10] + " عشر");
    } else {
      let tens = Math.floor(num / 10);
      let ones = num % 10;
      if (ones > 0) {
        parts.push(arabicOnes[ones] + " و " + arabicTens[tens]);
      } else {
        parts.push(arabicTens[tens]);
      }
    }
  }

  return parts.filter(Boolean).join(" و ") + " جنيه فقط لا غير";
}

function calculateDurationMonths(start, end) {
  const startDate = new Date(start);
  const endDate = new Date(end);
  if (isNaN(startDate) || isNaN(endDate)) return 0;
  let months = (endDate.getFullYear() - startDate.getFullYear()) * 12;
  months += endDate.getMonth() - startDate.getMonth();
  if (endDate.getDate() >= startDate.getDate()) months += 1;
  return months > 0 ? months : 0;
}

function saveTenants() {
  localStorage.setItem("tenants", JSON.stringify(receiptsData));
}

function renderTenantsList() {
  const container = document.getElementById("tenantsList");
  if (!container) return;
  container.innerHTML = "";
  receiptsData.forEach((tenant, index) => {
    const div = document.createElement("div");
    div.className = "tenant";
    div.innerHTML = `
      <div>الاسم: ${tenant.name}</div>
      <div>المبلغ: ${tenant.amount}</div>
      <div>الشقة: ${tenant.apartment_number}</div>
      <button onclick="openModal(${index})" style="background-color:#ffc107; color:black;">تعديل</button>
      <button onclick="deleteTenant(${index})" style="background-color:#dc3545; color:white;">حذف</button>
    `;
    container.appendChild(div);
  });
}

let editingIndex = -1;

function openModal(index = -1) {
  const modal = document.getElementById("tenantModal");
  const title = document.getElementById("modalTitle");
  const form = document.getElementById("tenantForm");

  editingIndex = index;

  if (index >= 0) {
    const tenant = receiptsData[index];
    title.textContent = "تعديل المستأجر";
    document.getElementById("tenantName").value = tenant.name;
    document.getElementById("tenantAmount").value = tenant.amount;
    document.getElementById("tenantApartment").value = tenant.apartment_number;
  } else {
    title.textContent = "إضافة مستأجر جديد";
    form.reset();
  }

  modal.style.display = "block";
}

document.addEventListener("DOMContentLoaded", () => {
  const tenantForm = document.getElementById("tenantForm");
  if (tenantForm) {
    tenantForm.addEventListener("submit", handleFormSubmit);
  }
});

function handleFormSubmit(e) {
  e.preventDefault();

  const name = document.getElementById("tenantName").value.trim();
  const amount = parseFloat(document.getElementById("tenantAmount").value);
  const apartment_number = document.getElementById("tenantApartment").value.trim();

  // التحققات
  if (!name) {
    alert("⚠️ يرجى إدخال اسم المستأجر");
    return;
  }
  
  if (name.length < 2) {
    alert("⚠️ اسم المستأجر يجب أن يكون حرفين على الأقل");
    return;
  }
  
  if (!apartment_number) {
    alert("⚠️ يرجى إدخال رقم الشقة");
    return;
  }
  
  if (isNaN(amount) || amount <= 0) {
    alert("⚠️ يرجى إدخال مبلغ صحيح أكبر من صفر");
    return;
  }
  
  if (amount > 100000) {
    alert("⚠️ المبلغ كبير جداً. يرجى التحقق من المبلغ المدخل");
    return;
  }
  
  // التحقق من التكرار
  const isDuplicate = receiptsData.some((tenant, idx) => {
    if (editingIndex >= 0 && idx === editingIndex) return false;
    return tenant.name.toLowerCase() === name.toLowerCase() && 
           tenant.apartment_number.toLowerCase() === apartment_number.toLowerCase();
  });
  
  if (isDuplicate) {
    alert("⚠️ يوجد مستأجر بنفس الاسم ورقم الشقة بالفعل!");
    return;
  }

  const tenantData = {
    name,
    amount,
    apartment_number,
    number: "70",
  };

  if (editingIndex >= 0) {
    receiptsData[editingIndex] = tenantData;
    alert("✓ تم تحديث بيانات المستأجر بنجاح!");
  } else {
    receiptsData.push(tenantData);
    alert("✓ تم إضافة المستأجر بنجاح!");
  }

  saveTenants();
  renderTenantsList();
  document.getElementById("tenantModal").style.display = "none";
}

function deleteTenant(index) {
  const tenant = receiptsData[index];
  const confirmMessage = `هل أنت متأكد من حذف المستأجر؟\n\nالاسم: ${tenant.name}\nالمبلغ: ${tenant.amount} جنيه\nالشقة: ${tenant.apartment_number}`;
  
  if (confirm(confirmMessage)) {
    receiptsData.splice(index, 1);
    saveTenants();
    renderTenantsList();
    alert("تم حذف المستأجر بنجاح ✓");
  }
}

function exportBackup() {
  const data = {
    tenants: receiptsData,
    exportDate: new Date().toISOString(),
    version: "1.0"
  };
  
  const dataStr = JSON.stringify(data, null, 2);
  const dataBlob = new Blob([dataStr], { type: 'application/json' });
  const url = URL.createObjectURL(dataBlob);
  const link = document.createElement('a');
  link.href = url;
  link.download = `backup-tenants-${new Date().toISOString().split('T')[0]}.json`;
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
  URL.revokeObjectURL(url);
  
  alert("✓ تم حفظ النسخة الاحتياطية بنجاح!");
}

async function initIndexPage() {
  // Load from localStorage first
  const savedTenants = localStorage.getItem("tenants");
  if (savedTenants) {
    receiptsData = JSON.parse(savedTenants);
  } else {
    // If no localStorage data, load from tenants.json
    receiptsData = await loadDefaultTenants();
    // Save to localStorage for future use
    if (receiptsData.length > 0) {
      saveTenants();
    }
  }
  
  renderTenantsList();
  const addBtn = document.getElementById("addTenantBtn");
  if (addBtn) addBtn.onclick = () => openModal();

  const proceedBtn = document.getElementById("proceedToFormBtn");
  if (proceedBtn)
    proceedBtn.onclick = () => {
      window.location.href = "form.html";
    };

  const backupBtn = document.getElementById("backupBtn");
  if (backupBtn) backupBtn.onclick = () => exportBackup();

  const closeBtn = document.querySelector(".close");
  const modal = document.getElementById("tenantModal");

  if (closeBtn) {
    closeBtn.onclick = () => {
      modal.style.display = "none";
    };
  }

  window.onclick = (event) => {
    if (event.target === modal) {
      modal.style.display = "none";
    }
  };
}

function initFormPage() {
  const dateStartFormInput = document.getElementById("dateStartForm");
  const dateEndAtInput = document.getElementById("dateEndAt");
  const form = document.getElementById("datesForm");

  const today = new Date().toISOString().split('T')[0];
  localStorage.setItem("releaseDate", today);

  const savedDateStartForm = localStorage.getItem("dateStartForm");
  const savedDateEndAt = localStorage.getItem("dateEndAt");
  if (savedDateStartForm) dateStartFormInput.value = savedDateStartForm;
  if (savedDateEndAt) dateEndAtInput.value = savedDateEndAt;

  form.onsubmit = (e) => {
    e.preventDefault();
    const dateStartForm = dateStartFormInput.value;
    const dateEndAt = dateEndAtInput.value;
    const releaseDate = today;
    if (!dateStartForm || !dateEndAt) {
      alert("يرجى إدخال التواريخ");
      return;
    }
    localStorage.setItem("dateStartForm", dateStartForm);
    localStorage.setItem("dateEndAt", dateEndAt);
    localStorage.setItem("releaseDate", releaseDate);
    window.location.href = "receipts.html";
  };
}

async function initReceiptsPage() {
  const container = document.getElementById("receiptsContainer");
  if (!container) return;

  // Load from localStorage first
  const savedTenants = localStorage.getItem("tenants");
  if (savedTenants) {
    receiptsData = JSON.parse(savedTenants);
  } else {
    // If no localStorage data, load from tenants.json
    receiptsData = await loadDefaultTenants();
  }

  const dateStartForm = localStorage.getItem("dateStartForm") || "";
  const dateEndAt = localStorage.getItem("dateEndAt") || "";
  const releaseDate = localStorage.getItem("releaseDate") || "";

  let pageDiv = null;
  receiptsData.forEach((tenant, index) => {
    const updatedTenant = {
      ...tenant,
      dateStartForm: dateStartForm,
      dateEndAt: dateEndAt,
      amountAsText: numberToArabicWords(tenant.amount),
    };

    if (index % 4 === 0) {
      if (pageDiv) container.appendChild(pageDiv);
      pageDiv = document.createElement("div");
      pageDiv.className = "receipt-page";
    }
    const receiptDiv = document.createElement("div");
    receiptDiv.className = "receipt";
    receiptDiv.innerHTML = `
      <div class="name">${updatedTenant.name}</div>
      <div class="amount">${updatedTenant.amount}.00</div>
      <div class="receipt-content">
        <div class="number">${updatedTenant.number !== undefined
        ? updatedTenant.number
        : "ssssssssssssss"
      }</div>
        <div class="amount-text">${updatedTenant.amountAsText}</div>
        <div class="date-start">${updatedTenant.dateStartForm}</div>
        <div class="date-end">${updatedTenant.dateEndAt}</div>
        <div class="duration">${calculateDurationMonths(
        updatedTenant.dateStartForm,
        updatedTenant.dateEndAt
      )} شهر</div>
        <div class="apartment">${updatedTenant.apartment_number}</div>
        <div class="address">عزبة بدران، شبرا الخيمة</div>
        <div class="release-date">${releaseDate}</div>
      </div>
    `;
    pageDiv.appendChild(receiptDiv);
  });

  if (pageDiv) container.appendChild(pageDiv);
}

document.addEventListener("DOMContentLoaded", async () => {
  if (document.getElementById("tenantsList")) {
    await initIndexPage();
  } else if (document.getElementById("datesForm")) {
    initFormPage();
  } else if (document.getElementById("receiptsContainer")) {
    await initReceiptsPage();
  }
});
