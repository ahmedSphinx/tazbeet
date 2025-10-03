// Load saved tenants from localStorage if available
let receiptsData = [
  {
    name: "عاطف راغب قطب",
    amount: 150.0,
    apartment_number: "شقة٢",
    number: "70",
    dateStartForm: "",
    dateEndAt: "",
  },
  {
    name: "احمد عاطف راغب قطب",
    amount: 200.0,
    apartment_number: "شقة٦",
    number: "70",
    dateStartForm: "",
    dateEndAt: "",
  },
  {
    name: "سيد علي بركات",
    amount: 120.0,
    apartment_number: "شقة٥",
    number: "70",
    dateStartForm: "",
    dateEndAt: "",
  },
  {
    name: "منى علي بركات",
    amount: 60.0,
    apartment_number: "شقة ١",
    number: "70",
    dateStartForm: "",
    dateEndAt: "",
  },
  {
    name: "محمد عبد الغفار",
    amount: 130.0,
    apartment_number: "شقة ٤",
    number: "70",
    dateStartForm: "",
    dateEndAt: "",
  },
  {
    name: "ناصر محمد مصطفى",
    amount: 120.0,
    apartment_number: "شقة ٣",
    number: "70",
    dateStartForm: "",
    dateEndAt: "",
  },
  {
    name: "هشام محمد حسن احمد",
    amount: 500.0,
    apartment_number: "محل",
    number: "70",
    dateStartForm: "",
    dateEndAt: "",
  },
];

// Arabic number words
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

  // Thousands
  let thousands = Math.floor(num / 1000);
  if (thousands > 0) {
    if (thousands === 1) parts.push("ألف");
    else if (thousands === 2) parts.push("ألفان");
    else if (thousands < 11) parts.push(arabicOnes[thousands] + " آلاف");
    else parts.push(numberToArabicWords(thousands) + " ألف");
  }

  num = num % 1000;

  // Hundreds
  let hundreds = Math.floor(num / 100);
  if (hundreds > 0) parts.push(arabicHundreds[hundreds]);

  num = num % 100;

  // Tens and ones
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
    document.getElementById("tenantDateStart").value = tenant.dateStartForm;
    document.getElementById("tenantDateEnd").value = tenant.dateEndAt;
    document.getElementById("tenantApartment").value = tenant.apartment_number;
  } else {
    title.textContent = "إضافة مستأجر جديد";
    form.reset();
  }

  modal.style.display = "block";
}

// Add event listener for tenant form submit
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
  const dateStartForm = document.getElementById("tenantDateStart").value;
  const dateEndAt = document.getElementById("tenantDateEnd").value;
  const apartment_number = document.getElementById("tenantApartment").value.trim();

  if (!name || isNaN(amount) || amount <= 0 || !dateStartForm || !dateEndAt || !apartment_number) {
    alert("يرجى ملء جميع الحقول بشكل صحيح");
    return;
  }

  const tenantData = {
    name,
    amount,
    amountAsText: numberToArabicWords(amount),
    dateStartForm,
    dateEndAt,
    apartment_number,
  };

  console.log("Editing index:", editingIndex);
  console.log("Tenant data to save:", tenantData);

  if (editingIndex >= 0) {
    receiptsData[editingIndex] = tenantData;
  } else {
    receiptsData.push(tenantData);
  }

  saveTenants();
  renderTenantsList();
  document.getElementById("tenantModal").style.display = "none";
  console.log("Tenants after save:", receiptsData);
}

function deleteTenant(index) {
  if (confirm("هل أنت متأكد من حذف المستأجر؟")) {
    receiptsData.splice(index, 1);
    saveTenants();
    renderTenantsList();
  }
}

function initIndexPage() {
  // Load tenants from localStorage if available
  const savedTenants = localStorage.getItem("tenants");
  if (savedTenants) {
    receiptsData = JSON.parse(savedTenants);
  }
  renderTenantsList();
  const addBtn = document.getElementById("addTenantBtn");
  if (addBtn) addBtn.onclick = () => openModal();

  const proceedBtn = document.getElementById("proceedToFormBtn");
  if (proceedBtn)
    proceedBtn.onclick = () => {
      window.location.href = "form.html";
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

function initReceiptsPage() {
  const container = document.getElementById("receiptsContainer");
  if (!container) return;

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
    // Instead of innerHTML +=, create receipt element and append
    const receiptDiv = document.createElement("div");
    receiptDiv.className = "receipt";
    receiptDiv.innerHTML = `
      <div class="name">${updatedTenant.name}</div>
      <div class="amount">${updatedTenant.amount}.00</div>
      <div class="receipt-content">
        <div class="number">${
          updatedTenant.number !== undefined
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

document.addEventListener("DOMContentLoaded", () => {
  if (document.getElementById("tenantsList")) {
    initIndexPage();
  } else if (document.getElementById("datesForm")) {
    initFormPage();
  } else if (document.getElementById("receiptsContainer")) {
    initReceiptsPage();
  }
});
