<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Category;
class CategorySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run()
    {
        Category::create([
            'name' => 'الأدوية',
            'img' => 'image1.jpg',
            'country' => 0,
        ]);

        Category::create([
            'name' => 'الالكترونيات',
            'img' => 'image2.jpg',
            'country' => 0,
        ]);

        // Add more seed data if needed
    }
}


