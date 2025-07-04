using UnityEngine;

namespace UIParticle
{
	[ExecuteAlways]
	[RequireComponent(typeof(CanvasRenderer))]
	public class MeshStackRenderer : MonoBehaviour
	{
		[SerializeField]
		private int count = 1;

		[SerializeField]
		private float distance = 0.5f;

		[SerializeField]
		private Material material;

		[SerializeField]
		private Texture texture;

		[SerializeField]
		private Texture alphaTexture;

		[SerializeField]
		[Range(0f, 1f)]
		private float alpha = 1;

		[SerializeField]
		private Color color = Color.white;
		
		private Mesh mesh;

		private RectTransform rectTransform;
		private CanvasRenderer canvasRenderer;

		public CanvasRenderer CanvasRenderer => canvasRenderer ??= GetComponent<CanvasRenderer>();

		public RectTransform RectTransform => rectTransform ??= GetComponent<RectTransform>();
		

		private void OnEnable()
		{
			UpdateGeometry();
		}

		private void OnValidate()
		{
			UpdateGeometry();
		}

		protected void UpdateGeometry()
		{
			mesh = new Mesh();

			Vector2 size = RectTransform.sizeDelta;

			var pivot = RectTransform.pivot;

			Vector3[] vertices = new Vector3[4 * count];
			Color[] colors = new Color[vertices.Length];
			int[] tris = new int[6 * count];

			float left = -pivot.x * size.x;
			float right = (1 - pivot.x) * size.x;
			float bottom = -pivot.y * size.y;
			float top = (1 - pivot.y) * size.y;

			for (int i = 0; i < count; i++)
			{
				vertices[4 * i + 0] = new Vector3(left, bottom, i * distance);
				vertices[4 * i + 1] = new Vector3(right, bottom, i * distance);
				vertices[4 * i + 2] = new Vector3(left, top, i * distance);
				vertices[4 * i + 3] = new Vector3(right, top, i * distance);

				float vertexTint = i / (float)(count - 1);
				var color = new Color(vertexTint, vertexTint, vertexTint, 1);

				colors[4 * i + 0] = color;
				colors[4 * i + 1] = color;
				colors[4 * i + 2] = color;
				colors[4 * i + 3] = color;
			}

			mesh.vertices = vertices;
			mesh.colors = colors;
			mesh.normals = QuadHelper.GetMultipleQuadNormals(count);
			mesh.uv = QuadHelper.GetMultipleQuadUVs(count);
			mesh.triangles = QuadHelper.GetMultipleQuadTriangles(count);

			CanvasRenderer.SetMesh(mesh);
			CanvasRenderer.SetMaterial(material ?? Canvas.GetDefaultCanvasMaterial(), null);
			CanvasRenderer.SetTexture(texture);
			CanvasRenderer.SetColor(color);
			CanvasRenderer.SetAlphaTexture(alphaTexture);
			CanvasRenderer.SetAlpha(alpha);
		}
	}
}