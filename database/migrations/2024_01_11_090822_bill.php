<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('bill', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('stores_id');
            $table->foreign('stores_id')->references('id')->on('stores')->onDelete('set null');
            $table->timestamp('created_at');
            // $table->timestamps();
            //default value 0->means the admin does not recieve bill
            $table->integer('status')->default(0);
            //من اجل عندما نريد ان نحذف الstore
            //نبقي الفواتير من اجل عملية التحليل المستقبلي للفواتير
            //ومن اجل عملية معرفة البيعات

            $table->integer('country')->default(0);//means yemen

        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('bill');

    }
};
