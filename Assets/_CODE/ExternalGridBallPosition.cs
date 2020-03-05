using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ExternalGridBallPosition : MonoBehaviour {

	public GameObject ball;
	public Material _mat;
	
	// Update is called once per frame
	void Update () {

		_mat.SetVector("_Pos", ball.transform.position);	
	}
}
