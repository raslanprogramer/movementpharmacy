<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\Request;
use App\Models\Product;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\File;
use App\Traits\CheckAuthForAdmin;

class ProductController extends Controller
{
    use CheckAuthForAdmin;
    public function index($category_id)
    {
        if(is_numeric($category_id))
        {
            $products = Product::where('category_id',    $category_id)->get(); 

            // $products=Category::find($category_id);
            // if(!is_null($products))
            // {
            // return response()->json(['data'=>$products->products]); 
            // }
            // return response()->json(['data'=>[]]); 
            return response()->json(['data'=>$products,'error'=>0]);
        }
        return response()->json(['error'=>5555]);
    }

    public function store(Request $request)
    {
        //store product in country
        $result=$this->registerOrNot($request);
        if($result["status"]==true)
        {
            if($result["rolls_name"]=="admin"|| $result["rolls_name"]=="country_manager")
            {
                $validator = Validator::make($request->all(), [
                    'name' => 'required|string',
                    'img' => 'required|image|mimes:jpeg,png,jpg,gif|max:6000',
                    'amount' => 'required|string',
                    'price' => 'required|numeric',
                    'category_id' => 'required|exists:category,id',
                    'country' => 'nullable|integer',
                ]);
            
                // Check if validation fails
                if ($validator->fails()) {
                    return response()->json($validator->errors(),400);
                }
            
                // Validation passed, create a new product instance
                $product = new Product();
                $product->name = $request->input('name');
                $product->amount = $request->input('amount');
                $product->price = $request->input('price');
                $product->category_id = $request->input('category_id');
                $product->country = $request->input('country', 0); // Use the provided country value or set the default value
        
                $image = $request->file('img');
                        $imageName = time() . '_' . $image->getClientOriginalName();
                        $image->move(public_path('images'), $imageName);
                        $product->img = $imageName;
        
                // Save the product
                $product->save();
                //هنا نقوم بارسال اشعار الى المستخدمين لإعلامهم باضافة منتج جديد
                $this->sendnotifcation_toTopic('منتج جديد','عزيزنا العميل نود اخطاركم بوجود منجات جديدة تم اضافتها للتو',$product->img,$product->country);

                return response()->json(['data'=>$product],201);
            }
            return response()->json(['message'=>"ليس لديك صلاحية","error"=>5555],401);
        }
        return response()->json(['message'=>"ليس لديك صلاحية","error"=>5555],401);
        
    }
    public function update(Request $request)
    {
        // Validate the input
        $result=$this->registerOrNot($request);
        if($result["status"]==true)
        {
            if($result["rolls_name"]=="admin"|| $result["rolls_name"]=="country_manager")
            {
                $validator = Validator::make($request->all(), [
                    'product_id'=>'required|integer',
                    'name' => 'required|string',
                    'img' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:6000',
            'amount' => 'required|string',
            'price' => 'required|numeric',
            'category_id' => 'required|exists:category,id',
            'country' => 'nullable|integer',
                ]);


                if ($validator->fails()) {
                    return response()->json($validator->errors(), 400);
                }
                $product = Product::findOrFail($request->product_id);
                if (!$product) {
                    return response()->json(['message'=>'هذا المنتج غير موجود'], 401);
                }
                // Validation passed, update the product instance
                $product->name = $request->input('name');
                $product->amount = $request->input('amount');
                $product->price = $request->input('price');
                $product->category_id = $request->input('category_id');
                $product->country = $request->input('country', 0); // Use the provided country value or set the default value
                if ($product->img && $request->hasFile('img')) {
                    $existingImagePath = public_path('images') . '/' . $product->img;
                    if (File::exists($existingImagePath)) {
                        // Remove the existing image from the public directory
                        File::delete($existingImagePath);
                    }
                }
                if ($request->hasFile('img')) {
                    $image = $request->file('img');
                    $imageName = time() . '_' . $image->getClientOriginalName();
                    $image->move(public_path('images'), $imageName);
                    $product->img = $imageName;
                }
                // Save the updated product
                $product->save();
            
                // Optionally, you can redirect to a different page
                return response()->json(['message'=>'تمت العملية بنجاح'],201);
            }
            return response()->json(['message'=>"ليس لديك صلاحية","error"=>5555],401);
        }
        return response()->json(['message'=>"ليس لديك صلاحية","error"=>5555],401);
    
        // Check if validation fails
        
    }

    public function destroy(Request $request)
    {
        $result=$this->registerOrNot($request);
        if($result["status"]==true)
        {
            if($result["rolls_name"]=="admin"|| $result["rolls_name"]=="country_manager")
            {

                $validator = Validator::make($request->all(),
                [
                    'product_id' => 'required|integer',
                ]
            );
            if ($validator->fails()) {
                return response()->json(['messafe'=>$validator->errors()], 400);
            }
            $product = Product::findOrFail($request->product_id);
            if (!$product) {
                return response()->json(['message'=>"هذه المنتج غير موجود"], 404);
            }

            //في حالة اراد المسوول في دولة معينة حذف منتج في دولة اخرى
            if($result["rolls_name"]=="country_manager" && $result["country"]!=$product->country)
            {
                return response()->json(['message'=>"ليس لديك صلاحية بحذف منتج خارج دولتك","error"=>5555],401);
            }
            if ($product->img) {
                $existingImagePath = public_path('images') . '/' . $product->img;
                if (File::exists($existingImagePath)) {
                    // Remove the existing image from the public directory
                    File::delete($existingImagePath);
                }
                
            }
            // Delete the product
            $product->delete();
    
            // Optionally, you can redirect to a different page
            return response()->json('product deleted successfully',201);
            }
            return response()->json(['message'=>"ليس لديك صلاحية","error"=>5555],401);
        }
        return response()->json(['message'=>"ليس لديك صلاحية","error"=>5555],401);
    }
}
