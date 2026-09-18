"use client";

import { useEffect, useState } from "react";
import { api } from "@/lib/api";

interface Stats {
  totalOrders: number;
  todayOrders: number;
  totalCustomers: number;
  activeMitras: number;
  totalRevenue: number;
  pendingOrders: number;
  onDeliveryOrders: number;
}

const statCards = [
  { key: "totalOrders", label: "Total Order", icon: "📦", color: "blue" },
  { key: "todayOrders", label: "Order Hari Ini", icon: "📅", color: "green" },
  { key: "totalRevenue", label: "Total Revenue", icon: "💰", color: "purple", isCurrency: true },
  { key: "totalCustomers", label: "Customers", icon: "👤", color: "orange" },
  { key: "activeMitras", label: "Mitra Aktif", icon: "🛵", color: "teal" },
  { key: "pendingOrders", label: "Order Pending", icon: "⏳", color: "yellow" },
  { key: "onDeliveryOrders", label: "Dalam Pengiriman", icon: "🚚", color: "indigo" },
];

const colorMap: Record<string, string> = {
  blue: "bg-blue-50 border-blue-200 text-blue-700",
  green: "bg-green-50 border-green-200 text-green-700",
  purple: "bg-purple-50 border-purple-200 text-purple-700",
  orange: "bg-orange-50 border-orange-200 text-orange-700",
  teal: "bg-teal-50 border-teal-200 text-teal-700",
  yellow: "bg-yellow-50 border-yellow-200 text-yellow-700",
  indigo: "bg-indigo-50 border-indigo-200 text-indigo-700",
};

function formatCurrency(amount: number) {
  return new Intl.NumberFormat("id-ID", { style: "currency", currency: "IDR", maximumFractionDigits: 0 }).format(amount);
}

export default function DashboardPage() {
  const [stats, setStats] = useState<Stats | null>(null);
  const [orders, setOrders] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    async function loadData() {
      try {
        const [ordersData] = await Promise.all([api.get("/orders")]);
        const today = new Date().toDateString();
        const todayOrders = ordersData.filter((o: any) => new Date(o.createdAt).toDateString() === today);
        const revenue = ordersData.filter((o: any) => o.status === "DELIVERED").reduce((s: number, o: any) => s + o.total, 0);
        setOrders(ordersData.slice(0, 5));
        setStats({
          totalOrders: ordersData.length,
          todayOrders: todayOrders.length,
          totalCustomers: new Set(ordersData.map((o: any) => o.customerId)).size,
          activeMitras: 1,
          totalRevenue: revenue,
          pendingOrders: ordersData.filter((o: any) => o.status === "PENDING").length,
          onDeliveryOrders: ordersData.filter((o: any) => o.status === "ON_DELIVERY").length,
        });
      } catch {
        setError("Gagal memuat data. Pastikan backend berjalan.");
      } finally {
        setLoading(false);
      }
    }
    loadData();
  }, []);

  if (loading) return <div className="text-center py-20 text-gray-500">Memuat data...</div>;
  if (error) return <div className="bg-red-50 text-red-700 p-4 rounded-xl">{error}</div>;

  const statusBadge = (status: string) => {
    const map: Record<string, string> = {
      PENDING: "bg-orange-100 text-orange-700",
      CONFIRMED: "bg-blue-100 text-blue-700",
      SHOPPING: "bg-purple-100 text-purple-700",
      ON_DELIVERY: "bg-indigo-100 text-indigo-700",
      DELIVERED: "bg-green-100 text-green-700",
      CANCELLED: "bg-red-100 text-red-700",
    };
    const labels: Record<string, string> = {
      PENDING: "Menunggu", CONFIRMED: "Konfirmasi", SHOPPING: "Belanja",
      ON_DELIVERY: "Dikirim", DELIVERED: "Terkirim", CANCELLED: "Batal",
    };
    return (
      <span className={`px-2.5 py-1 rounded-full text-xs font-medium ${map[status] || "bg-gray-100 text-gray-700"}`}>
        {labels[status] || status}
      </span>
    );
  };

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-xl font-bold text-gray-900">Selamat datang 👋</h2>
        <p className="text-gray-500 text-sm mt-1">Ringkasan aktivitas Jastip Wirosari</p>
      </div>

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        {statCards.map((card) => (
          <div key={card.key} className={`border rounded-2xl p-4 ${colorMap[card.color]}`}>
            <div className="text-2xl mb-2">{card.icon}</div>
            <div className="text-lg font-bold">
              {card.isCurrency
                ? formatCurrency((stats as any)?.[card.key] ?? 0)
                : (stats as any)?.[card.key] ?? 0}
            </div>
            <div className="text-sm opacity-80">{card.label}</div>
          </div>
        ))}
      </div>

      <div className="bg-white rounded-2xl border p-6">
        <h3 className="font-semibold text-gray-800 mb-4">Order Terbaru</h3>
        {orders.length === 0 ? (
          <p className="text-gray-400 text-sm text-center py-8">Belum ada order</p>
        ) : (
          <table className="w-full text-sm">
            <thead>
              <tr className="text-left text-gray-500 border-b">
                <th className="pb-2">No. Order</th>
                <th className="pb-2">Tipe</th>
                <th className="pb-2">Total</th>
                <th className="pb-2">Status</th>
                <th className="pb-2">Waktu</th>
              </tr>
            </thead>
            <tbody>
              {orders.map((order) => (
                <tr key={order.id} className="border-b last:border-0">
                  <td className="py-3 font-mono text-xs">{order.orderNumber}</td>
                  <td className="py-3">
                    <span className={`px-2 py-0.5 rounded text-xs ${order.orderType === "CUSTOM_JASTIP" ? "bg-amber-100 text-amber-700" : "bg-blue-100 text-blue-700"}`}>
                      {order.orderType === "CUSTOM_JASTIP" ? "Custom" : "Produk"}
                    </span>
                  </td>
                  <td className="py-3">{formatCurrency(order.total)}</td>
                  <td className="py-3">{statusBadge(order.status)}</td>
                  <td className="py-3 text-gray-400">
                    {new Date(order.createdAt).toLocaleDateString("id-ID", { day: "numeric", month: "short", hour: "2-digit", minute: "2-digit" })}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
}
