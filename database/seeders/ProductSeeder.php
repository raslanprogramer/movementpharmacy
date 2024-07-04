<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Product;
class ProductSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Product::create(
            [
                'name' => 'سلبادين 725 مج',
                'img' => '1705218559_a1.png',
                'amount' => '10 أقراص',
                'price' => 1200,
                'category_id' => 1,
                'country' => 0,
            ]
        );
        Product::create(
            [
                'name' => 'فوار اماراتي',
                'img'=>'1705218582_5dc968e9-8b0b-44cf-8844-4dfb86ad8c51.jpg',
                'amount' => '10 أقراص',
                'price' => 1200,
                'category_id' => 2,
                'country' => 0,
            ]
        );
    }
}
