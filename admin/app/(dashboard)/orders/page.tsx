"use client";

import { useEffect, useState } from "react";
import { api } from "@/lib/api";

const statusLabels: Record<string, string> = {
  PENDING: "Menunggu", CONFIRMED: "Dikonfirmasi", SHOPPING: "Belanja",
  READY_TO_DELIVER: "Siap Kirim", ON_DELIVERY: "Dikirim", DELIVERED: "Terkirim",
  CANCELLED: "Dibatalkan", WAITING_QUOTE: "Tunggu Harga", WAITING_APPROVAL: "Tunggu Approve",
};

const statusColors: Record<string, string> = {
  PENDING: "bg-orange-100 text-orange-700", CONFIRMED: "bg-blue-100 text-blue-700",
  SHOPPING: "bg-purple-100 text-purple-700", READY_TO_DELIVER: "bg-teal-100 text-teal-700",
  ON_DELIVERY: "bg-indigo-100 text-indigo-700", DELIVERED: "bg-green-100 text-green-700",
  CANCELLED: "bg-red-100 text-red-700",
};

function fmt(n: number) {
  return new Intl.NumberFormat("id-ID", { style: "currency", currency: "IDR", maximumFractionDigits: 0 }).format(n);
}

export default function OrdersPage() {
  const [orders, setOrders] = useState<any[]>([]);
  const [filter, setFilter] = useState("ALL");
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    api.get("/orders").then(setOrders).finally(() => setLoading(false));
  }, []);

  const filtered = filter === "ALL" ? orders : orders.filter((o) => o.status === filter);
  const statuses = ["ALL", "PENDING", "CONFIRMED", "SHOPPING", "ON_DELIVERY", "DELIVERED", "CANCELLED"];

  return (
    <div className="space-y-4">
      <div className="flex flex-wrap gap-2">
        {statuses.map((s) => (
          <button
            key={s}
            onClick={() => setFilter(s)}
            className={`px-3 py-1.5 rounded-full text-sm font-medium transition ${filter === s ? "bg-blue-600 text-white" : "bg-white border text-gray-600 hover:border-blue-400"}`}
          >
            {s === "ALL" ? "Semua" : statusLabels[s]}
            {s === "ALL" && ` (${orders.length})`}
          </button>
        ))}
      </div>

      {loading ? (
        <div className="text-center py-20 text-gray-400">Memuat...</div>
      ) : (
        <div className="bg-white rounded-2xl border overflow-hidden">
          <table className="w-full text-sm">
            <thead className="bg-gray-50 border-b">
              <tr>
                {["No. Order", "Tipe", "Items", "Total", "Status", "Waktu"].map((h) => (
                  <th key={h} className="text-left px-4 py-3 text-gray-500 font-medium">{h}</th>
                ))}
              </tr>
            </thead>
            <tbody>
              {filtered.length === 0 ? (
                <tr><td colSpan={6} className="text-center py-12 text-gray-400">Tidak ada order</td></tr>
              ) : (
                filtered.map((order) => (
                  <tr key={order.id} className="border-b last:border-0 hover:bg-gray-50">
                    <td className="px-4 py-3 font-mono text-xs text-gray-600">{order.orderNumber}</td>
                    <td className="px-4 py-3">
                      <span className={`px-2 py-0.5 rounded text-xs ${order.orderType === "CUSTOM_JASTIP" ? "bg-amber-100 text-amber-700" : "bg-blue-100 text-blue-700"}`}>
                        {order.orderType === "CUSTOM_JASTIP" ? "Custom" : "Produk"}
                      </span>
                    </td>
                    <td className="px-4 py-3 text-gray-600">{order.items?.length || 0} item</td>
                    <td className="px-4 py-3 font-medium">{fmt(order.total)}</td>
                    <td className="px-4 py-3">
                      <span className={`px-2.5 py-1 rounded-full text-xs font-medium ${statusColors[order.status] || "bg-gray-100"}`}>
                        {statusLabels[order.status] || order.status}
                      </span>
                    </td>
                    <td className="px-4 py-3 text-gray-400 text-xs">
                      {new Date(order.createdAt).toLocaleDateString("id-ID", { day: "numeric", month: "short", hour: "2-digit", minute: "2-digit" })}
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
