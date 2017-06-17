let render = () => {
  let preview = $('#preview')

  let data = new FormData()
  data.append("dotcode", $('#dotcode').value)

  let opts = { method: 'POST',
               body: data };

  fetch('render', opts)
  .then(res => { return res.blob() })
  .then(blob => {
    preview.src = URL.createObjectURL(blob)
  });
}