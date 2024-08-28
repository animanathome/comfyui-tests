def get_node_index(workflow, classtype):
    for key, value in workflow.items():
        node = workflow[key]
        if node['class_type'] == classtype:
            return key

    return None

def set_image_input(workflow, input_image_file):
    index = get_node_index(workflow, "LoadImage")
    if not index:
        raise ValueError("LoadImage node not found in workflow")

    workflow[index]['inputs']['image'] = input_image_file

    return workflow