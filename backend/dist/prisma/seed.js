"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const bcrypt = require("bcrypt");
const prisma = new client_1.PrismaClient();
async function main() {
    console.log("Seeding database...");
    const adminPass = await bcrypt.hash("admin123", 10);
    const admin = await prisma.user.upsert({
        where: { phone: "081111111111" },
        update: {},
        create: { name: "Admin Jastip", phone: "081111111111", email: "admin@jastip.id", password: adminPass, role: "ADMIN" },
    });
    console.log("Admin created:", admin.id);
    const mitraPass = await bcrypt.hash("mitra123", 10);
    const mitraUser = await prisma.user.upsert({
        where: { phone: "082222222222" },
        update: {},
        create: { name: "Budi Santoso", phone: "082222222222", password: mitraPass, role: "MITRA" },
    });
    await prisma.mitraProfile.upsert({
        where: { userId: mitraUser.id },
        update: {},
        create: { userId: mitraUser.id, isOnline: true, area: "Wirosari", vehicleType: "Motor", vehicleNumber: "H 1234 AB" },
    });
    console.log("Mitra created:", mitraUser.id);
    const custPass = await bcrypt.hash("customer123", 10);
    const customer = await prisma.user.upsert({
        where: { phone: "083333333333" },
        update: {},
        create: { name: "Ahmad Wirosari", phone: "083333333333", email: "ahmad@wirosari.id", password: custPass, role: "CUSTOMER" },
    });
    console.log("Customer created:", customer.id);
    const categories = [
        { name: "Sembako" }, { name: "Makanan" }, { name: "Minuman" },
        { name: "Sayur & Buah" }, { name: "Perawatan" }, { name: "Elektronik" },
        { name: "Fashion" }, { name: "Lainnya" },
    ];
    const createdCategories = [];
    for (const cat of categories) {
        const c = await prisma.category.upsert({
            where: { id: cat.name },
            update: {},
            create: cat,
        }).catch(() => prisma.category.create({ data: cat }));
        createdCategories.push(c);
    }
    console.log("Categories created:", createdCategories.length);
    const store1 = await prisma.store.upsert({
        where: { id: "store-1" },
        update: {},
        create: { id: "store-1", name: "Indomaret Wirosari", description: "Minimarket lengkap di pusat kota.", address: "Jl. Wirosari No. 1, Wirosari, Grobogan", latitude: -7.0564, longitude: 111.0031 },
    });
    const store2 = await prisma.store.upsert({
        where: { id: "store-2" },
        update: {},
        create: { id: "store-2", name: "Alfamart Wirosari", description: "Belanja kebutuhan sehari-hari.", address: "Jl. Raya Wirosari, Grobogan", latitude: -7.0571, longitude: 111.0038 },
    });
    const store3 = await prisma.store.upsert({
        where: { id: "store-3" },
        update: {},
        create: { id: "store-3", name: "Toko Sembako Bu Sri", description: "Sembako lengkap, harga grosir.", address: "Pasar Wirosari, Grobogan" },
    });
    console.log("Stores created");
    const sembakoId = createdCategories[0].id;
    const makananId = createdCategories[1].id;
    const minumanId = createdCategories[2].id;
    const perawatanId = createdCategories[4].id;
    const products = [
        { storeId: store1.id, categoryId: sembakoId, name: "Beras Rojolele 5kg", description: "Beras premium, pulen dan wangi.", price: 65000, stock: 50 },
        { storeId: store1.id, categoryId: minumanId, name: "Aqua 1.5L", description: "Air mineral botol besar.", price: 5000, stock: 100 },
        { storeId: store1.id, categoryId: sembakoId, name: "Minyak Bimoli 2L", description: "Minyak goreng sawit pilihan.", price: 38000, stock: 30 },
        { storeId: store2.id, categoryId: makananId, name: "Indomie Goreng Ayam", description: "Mi instan favorit rasa ayam panggang.", price: 3500, stock: 200 },
        { storeId: store2.id, categoryId: perawatanId, name: "Sabun Lifebuoy 100g", description: "Sabun antibakteri keluarga.", price: 5500, stock: 80 },
        { storeId: store3.id, categoryId: sembakoId, name: "Gula Pasir 1kg", description: "Gula pasir putih berkualitas.", price: 16000, stock: 60 },
        { storeId: store1.id, categoryId: sembakoId, name: "Tepung Terigu 1kg", description: "Tepung serbaguna.", price: 13000, stock: 40 },
        { storeId: store2.id, categoryId: minumanId, name: "Teh Botol Sosro 450ml", description: "Minuman teh segar.", price: 6000, stock: 150 },
    ];
    for (const p of products) {
        await prisma.product.create({ data: p });
    }
    console.log("Products created:", products.length);
    const areas = [
        { name: "Zone A (0-2 km)", description: "Dalam kota Wirosari", baseFee: 5000, maxDistance: 2 },
        { name: "Zone B (2-5 km)", description: "Sekitar kota Wirosari", baseFee: 8000, maxDistance: 5 },
        { name: "Zone C (5-8 km)", description: "Pinggir kota", baseFee: 12000, maxDistance: 8 },
        { name: "Zone D (8-15 km)", description: "Desa sekitar Wirosari", baseFee: 18000, maxDistance: 15 },
    ];
    for (const a of areas) {
        await prisma.area.create({ data: a });
    }
    console.log("Areas created:", areas.length);
    console.log("\nSeeding complete!");
    console.log("Login credentials:");
    console.log("  Admin:    081111111111 / admin123");
    console.log("  Mitra:    082222222222 / mitra123");
    console.log("  Customer: 083333333333 / customer123");
}
main()
    .catch(console.error)
    .finally(() => prisma.$disconnect());
//# sourceMappingURL=seed.js.map