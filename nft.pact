(module test-nft-project "test-nft-project-keyset" "A test NFT project"


    ; "Schemas" define what tables that store data look like
    ; Here we just define a basic schema to store owners 
    ; The "key" for each entry in the table will be the NFT ID
    ; and the value fetched for each ID will be the owner
    (defschema owners-schema
        @doc "Stores the owner information for each nft"
        owner-address:string
    )

    ; The schema defined what the table should look like
    ; Here we define the actual table that will store the data
    (deftable owners:{owners-schema})

    (defun set-owner(owner-address:string nft-id:string)
        @doc "Set the owner of an NFT - only available for admin"
        ; This function enforces that the caller of this function 
        ; is you (by checking the keyset)
        (enforce-keyset  (read-keyset "test-nft-project-keyset"))
        (insert owners nft-id {"owner-address": owner-address})
    )

    (defun get-owner (nft-id:string)
        @doc "Gets the owner of an NFT"
        ; This returns the owner-address field by reading it from the table
        (at "owner-address" (read owners nft-id ['owner-address] ))
    )

    ; This is the function to get the image of your NFT
    ; it takes an ID as the input and returns its URL
    ; PS - this is the same function as on the current Marmalade standard :)
    (defun uri:string (id:string)
        @doc
        " Give URI for ID. If not supported, return \"\" (empty string)."

        ; This will take the url of the website you uplaoded your image to
        ; and then add the id and .jpg to the end of it
        ; For example if your website is "https://my-cool-website/" and the 
        ; id is "1" then this will return "https://my-cool-website/1.jpg"
        (+ "https://your-website-url/"
            ; replace .jpg with whatever format your NFTs are
            (+ id ".jpg")
        )
    )
)

; Creating tables must be done outside of the module, just how it works
; Note if you end up re-deploying the code, you must delete this line or
; it will try to recreate the table and fail since it already exists
