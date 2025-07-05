using UnityEngine;

namespace UIParticle
{
	public static class QuadHelper
	{
		public static Vector2[] GetQuadUVs()
		{
			var uv = new Vector2[4];
			uv[0] = new Vector2(0, 0);
			uv[1] = new Vector2(0, 1);
			uv[2] = new Vector2(1, 1);
			uv[3] = new Vector2(1, 0);
			return uv;
		}

		public static Vector2[] GetMultipleQuadUVs(int count)
		{
			var singleUV = GetQuadUVs();
			var allUV = new Vector2[singleUV.Length * count];
			for (int i = 0; i < count; i++)
			{
				for (int j = 0; j < singleUV.Length; j++)
				{
					allUV[i * singleUV.Length + j] = singleUV[j];
				}
			}

			return allUV;
		}

		public static Vector3[] GetQuadNormals()
		{
			var normals = new Vector3[4];
			normals[0] = -Vector3.forward;
			normals[1] = -Vector3.forward;
			normals[2] = -Vector3.forward;
			normals[3] = -Vector3.forward;
			return normals;
		}

		public static Vector3[] GetMultipleQuadNormals(int count)
		{
			var normals = new Vector3[4 * count];
			for (int i = 0; i < count * 4; i++)
			{
				normals[i] = -Vector3.forward;
			}

			return normals;
		}

		public static int[] GetQuadTriangles()
		{
			var triangles = new int[6];
			triangles[0] = 0;
			triangles[1] = 1;
			triangles[2] = 2;
			triangles[3] = 2;
			triangles[4] = 1;
			triangles[5] = 3;
			return triangles;
		}

		public static int[] GetMultipleQuadTriangles(int count)
		{
			var singleTriangles = GetQuadTriangles();
			var triangles = new int[6 * count];
			for (int i = 0; i < count; i++)
			{
				int triangleIndex = i * 6;
				int vertexIndex = i * 4;
				for (int j = 0; j < 6; j++)
				{
					triangles[triangleIndex + j] = vertexIndex + singleTriangles[j];
				}
			}

			return triangles;
		}
	}
}