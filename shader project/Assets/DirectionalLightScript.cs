using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DirectionalLightScript : MonoBehaviour
{

    public Transform directionalLightTransform; // Assign the Directional Light's GameObject here

    public Material needsLightingVector;

    // Start is called before the first frame update
    private void Start()
    {
        GameObject obj = GameObject.FindGameObjectWithTag("NeedsLightingDirection");
        Renderer r = obj.GetComponent<Renderer>();
        needsLightingVector = r.material;
    }


    private void Update()
    {
        needsLightingVector.SetVector("_LightDirection", transform.rotation * Vector3.back);
        
        
    }


}

