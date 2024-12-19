# import os
# os.environ['KMP_DUPLICATE_LIB_OK']='True'
# import torch
# import torchvision
# from torchvision import datasets, transforms
# from torch import nn
# from PIL import Image
# 
# # 获取类别名称
# def get_classes(data_dir):
#     all_data = datasets.ImageFolder(data_dir)
#     return all_data.classes
# 
# def MyModel(classes):
#     model = torchvision.models.efficientnet_b0(pretrained=False)
#     n_inputs = model.classifier[1].in_features
#     model.classifier = nn.Sequential(
#         nn.Linear(n_inputs, 2048),  # 增加第一个全连接层的大小
#         nn.SiLU(),
#         nn.Dropout(0.3),
#         nn.Linear(2048, 2048),  # 增加另一个全连接层
#         nn.SiLU(),
#         nn.Dropout(0.3),
#         nn.Linear(2048, len(classes))  # 调整输出大小以匹配类的数量
#     )
#     return model
# 
# def apply_test_transforms():
#     # 使用 Compose 统一处理
#     return transforms.Compose([
#         transforms.Resize((224, 224)),
#         transforms.ToTensor(),
#         transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
#     ])
# 
# def predict_with_checkpoint(checkpoint_path, image_path, device='cuda'):
#     # 获取类
#     dataset_path = 'D:/_laboratory/pythonProject/DIP/CUB_200_2011/images'
#     classes = get_classes(dataset_path)
# 
#     # 加载模型和检查点
#     checkpoint = torch.load(checkpoint_path, map_location=device)
#     model = MyModel(classes)
#     # 查看模型的state_dict
#     model.load_state_dict(checkpoint['model_state_dict'])  # 加载模型权重,strict=False
#     model.to(device)
#     model.eval()  # 设置为评估模式
# 
#     # 图像预处理
#     transform = apply_test_transforms()
#     im = Image.open(image_path)
#     image_tensor = transform(im).to(device)
# 
#     # 推理
#     with torch.no_grad():
#         minibatch = torch.stack([image_tensor])
#         outputs = model(minibatch)
#         _, predicted_class = torch.max(outputs, 1)  # 获取预测类别索引
# 
#     # 返回类别名称
#     return classes[predicted_class.item()]


import os

os.environ['KMP_DUPLICATE_LIB_OK'] = 'True'
import torch
import torchvision
from torchvision import datasets, transforms
from torch import nn
from PIL import Image


# 获取类别名称
def get_classes(data_dir):
    all_data = datasets.ImageFolder(data_dir)
    return all_data.classes


def MyModel(classes):
    model = torchvision.models.efficientnet_b0(pretrained=False)
    n_inputs = model.classifier[1].in_features
    model.classifier = nn.Sequential(
        nn.Linear(n_inputs, 2048),  # 增加第一个全连接层的大小
        nn.SiLU(),
        nn.Dropout(0.3),
        nn.Linear(2048, 2048),  # 增加另一个全连接层
        nn.SiLU(),
        nn.Dropout(0.3),
        nn.Linear(2048, len(classes))  # 调整输出大小以匹配类的数量
    )
    return model


def apply_test_transforms():
    # 使用 Compose 统一处理
    return transforms.Compose([
        transforms.Resize((224, 224)),
        transforms.ToTensor(),
        transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
    ])


def predict_with_checkpoint(checkpoint_path, image_path, device='cuda'):
    # 获取类
    dataset_path = 'D:/_laboratory/pythonProject/DIP/CUB_200_2011/images'
    classes = get_classes(dataset_path)

    # 加载模型和检查点
    checkpoint = torch.load(checkpoint_path, map_location=device)
    # print("查看模型权重的所有键")
    # print(checkpoint['model_state_dict'].keys())  # 查看模型权重的所有键
    model = MyModel(classes)
    # print("打印模型结构")
    # print(model)  # 打印模型结构

    # 查看模型的state_dict
    # print("查看模型当前结构的state_dict键")
    # print(model.state_dict().keys())  # 查看模型当前结构的state_dict键

    model.load_state_dict(checkpoint['model_state_dict'])  # 加载模型权重
    model.to(device)
    model.eval()  # 设置为评估模式

    # 图像预处理
    transform = apply_test_transforms()
    im = Image.open(image_path)
    image_tensor = transform(im).to(device)

    # 推理
    with torch.no_grad():
        minibatch = torch.stack([image_tensor])
        outputs = model(minibatch)
        _, predicted_class = torch.max(outputs, 1)  # 获取预测类别索引

    # 返回类别名称
    return classes[predicted_class.item()]