//
//  SCNViewController.m
//  ARPlayDemo
//
//  Created by alexyang on 2017/7/11.
//  Copyright © 2017年 alexyang. All rights reserved.
//

#import "SCNViewController.h"
//3D游戏框架
#import <SceneKit/SceneKit.h>
//ARKit框架
#import <ARKit/ARKit.h>

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface SCNViewController ()<ARSCNViewDelegate,ARSessionDelegate>
{
    
    BOOL addedNode;
}
//AR视图：展示3D界面
@property (nonatomic, strong)ARSCNView *arSCNView;
@property (nonatomic, strong)ARSCNView *arLeftView;
@property (nonatomic, strong)ARSCNView *arRightView;

//AR会话，负责管理相机追踪配置及3D相机坐标
@property(nonatomic,strong)ARSession *arSession;

//会话追踪配置
@property(nonatomic,strong)ARWorldTrackingConfiguration *arSessionConfiguration;

//Node对象
@property(nonatomic, strong) SCNNode *sunNode;
@property(nonatomic, strong) SCNNode *sunNodeL;
@property(nonatomic, strong) SCNNode *earthNode;
@property(nonatomic, strong) SCNNode *earthNodeL;
@property(nonatomic, strong) SCNNode *moonNode;
@property(nonatomic, strong) SCNNode *moonNodeL;
@property(nonatomic, strong) SCNNode *marsNode; //火星
@property(nonatomic, strong) SCNNode *marsNodeL;
@property(nonatomic, strong) SCNNode *mercuryNode;//水星
@property(nonatomic, strong) SCNNode *mercuryNodeL;
@property(nonatomic, strong) SCNNode *venusNode;//金星
@property(nonatomic, strong) SCNNode *venusNodeL;
@property(nonatomic, strong) SCNNode *jupiterNode; //木星
@property(nonatomic, strong) SCNNode *jupiterNodeL;
@property(nonatomic, strong) SCNNode *jupiterLoopNode; //木星环
@property(nonatomic, strong) SCNNode *jupiterLoopNodeL;
@property(nonatomic, strong) SCNNode *jupiterGroupNode;//木星环
@property(nonatomic, strong) SCNNode *jupiterGroupNodeL;
@property(nonatomic, strong) SCNNode *saturnNode; //土星
@property(nonatomic, strong) SCNNode *saturnNodeL;
@property(nonatomic, strong) SCNNode *saturnLoopNode; //土星环
@property(nonatomic, strong) SCNNode *saturnLoopNodeL;
@property(nonatomic, strong) SCNNode *sartunGruopNode;//土星Group
@property(nonatomic, strong) SCNNode *sartunGruopNodeL;
@property(nonatomic, strong) SCNNode *uranusNode; //天王星
@property(nonatomic, strong) SCNNode *uranusNodeL;
@property(nonatomic, strong) SCNNode *uranusLoopNode; //天王星环
@property(nonatomic, strong) SCNNode *uranusLoopNodeL;
@property(nonatomic, strong) SCNNode *uranusGroupNode; //天王星Group
@property(nonatomic, strong) SCNNode *uranusGroupNodeL;
@property(nonatomic, strong) SCNNode *neptuneNode; //海王星
@property(nonatomic, strong) SCNNode *neptuneNodeL;
@property(nonatomic, strong) SCNNode *neptuneLoopNode; //海王星环
@property(nonatomic, strong) SCNNode *neptuneLoopNodeL;
@property(nonatomic, strong) SCNNode *neptuneGroupNode; //海王星Group
@property(nonatomic, strong) SCNNode *neptuneGroupNodeL;
@property(nonatomic, strong) SCNNode *plutoNode; //冥王星
@property(nonatomic, strong) SCNNode *plutoNodeL;
@property(nonatomic, strong) SCNNode *earthGroupNode;
@property(nonatomic, strong) SCNNode *earthGroupNodeL;
@property(nonatomic, strong) SCNNode *sunHaloNode;
@property(nonatomic, strong) SCNNode *sunHaloNodeL;
@end

@implementation SCNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    //当VR镜头模式下，显示左边视图
    if (_isCardBoard)
        [self.view addSubview:self.arLeftView];
    [self.view addSubview:self.arRightView];
    [self initNode];
    
    [self.arSession runWithConfiguration:self.arSessionConfiguration];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initWithLeftNode:(SCNView *) scnView {
    
    _sunNodeL = [SCNNode new];
    _mercuryNodeL = [SCNNode new];
    _venusNodeL = [SCNNode new];
    _earthNodeL = [SCNNode new];
    _moonNodeL = [SCNNode new];
    _marsNodeL = [SCNNode new];
    _earthGroupNodeL = [SCNNode new];
    _jupiterNodeL = [SCNNode new];
    _saturnNodeL = [SCNNode new];
    //_saturnLoopNode = [SCNNode new];
    _sartunGruopNodeL = [SCNNode new];
    _uranusNodeL = [SCNNode new];
    _neptuneNodeL = [SCNNode new];
    _plutoNodeL = [SCNNode new];
    
    _sunNodeL.geometry = [SCNSphere sphereWithRadius:0.25];
    _mercuryNodeL.geometry = [SCNSphere sphereWithRadius:0.02];
    _venusNodeL.geometry = [SCNSphere sphereWithRadius:0.04];
    _marsNodeL.geometry = [SCNSphere sphereWithRadius:0.03];
    _earthNodeL.geometry = [SCNSphere sphereWithRadius:0.05];
    _moonNodeL.geometry = [SCNSphere sphereWithRadius:0.01];
    _jupiterNodeL.geometry = [SCNSphere sphereWithRadius:0.15];
    _saturnNodeL.geometry = [SCNSphere sphereWithRadius:0.12];
    _uranusNodeL.geometry = [SCNSphere sphereWithRadius:0.09];
    _neptuneNodeL.geometry = [SCNSphere sphereWithRadius:0.08];
    _plutoNodeL.geometry = [SCNSphere sphereWithRadius:0.04];
    
    _moonNodeL.position = SCNVector3Make(0.1, 0, 0);
    [_earthGroupNodeL addChildNode:_earthNodeL];
    
    [_sartunGruopNodeL addChildNode:_saturnNodeL];
    
    //添加土星环
    SCNNode *saturnLoopNodeL = [SCNNode new];
    saturnLoopNodeL.opacity = 0.4;
    saturnLoopNodeL.geometry = [SCNBox boxWithWidth:0.6 height:0 length:0.6 chamferRadius:0];
    saturnLoopNodeL.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/saturn_loop.png";
    saturnLoopNodeL.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    saturnLoopNodeL.rotation = SCNVector4Make(-0.5, -1, 0, M_PI_2);
    saturnLoopNodeL.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant; // no lighting
    [_sartunGruopNodeL addChildNode:saturnLoopNodeL];
    
    _mercuryNodeL.position = SCNVector3Make(0.4, 0, 0);
    _venusNodeL.position = SCNVector3Make(0.6, 0, 0);
    _earthGroupNodeL.position = SCNVector3Make(0.8, 0, 0);
    _marsNodeL.position = SCNVector3Make(1.0, 0, 0);
    _jupiterNodeL.position = SCNVector3Make(1.4, 0, 0);
    _sartunGruopNodeL.position = SCNVector3Make(1.68, 0, 0);
    _uranusNodeL.position = SCNVector3Make(1.95, 0, 0);
    _neptuneNodeL.position = SCNVector3Make(2.14, 0, 0);
    _plutoNodeL.position = SCNVector3Make(2.319, 0, 0);
    
    [_sunNodeL setPosition:SCNVector3Make(0, -0.1, -3)];
    
    [scnView.scene.rootNode addChildNode:_sunNodeL];
    
    //水星贴图
    _mercuryNodeL.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/mercury.jpg";
    //金星贴图
    _venusNodeL.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/venus.jpg";
    //火星贴图
    _marsNodeL.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/mars.jpg";
    
    // 地球贴图
    _earthNodeL.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/earth-diffuse-mini.jpg";
    _earthNodeL.geometry.firstMaterial.emission.contents = @"art.scnassets/earth/earth-emissive-mini.jpg";
    _earthNodeL.geometry.firstMaterial.specular.contents = @"art.scnassets/earth/earth-specular-mini.jpg";
    //月球贴图
    _moonNodeL.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/moon.jpg";
    
    //木星贴图
    _jupiterNodeL.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/jupiter.jpg";
    //土星贴图
    _saturnNodeL.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/saturn.jpg";
    _saturnLoopNodeL.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/saturn_loop.jpg";
    //天王星
    _uranusNodeL.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/uranus.jpg";
    //海王星
    _neptuneNodeL.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/neptune.jpg";
    //冥王星
    _plutoNodeL.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/pluto.jpg";
    
    //太阳贴图
    _sunNodeL.geometry.firstMaterial.multiply.contents = @"art.scnassets/earth/sun.jpg";
    _sunNodeL.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/sun.jpg";
    _sunNodeL.geometry.firstMaterial.multiply.intensity = 0.5;
    _sunNodeL.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant;
    
    _sunNodeL.geometry.firstMaterial.multiply.wrapS =
    _sunNodeL.geometry.firstMaterial.diffuse.wrapS  =
    _sunNodeL.geometry.firstMaterial.multiply.wrapT =
    _sunNodeL.geometry.firstMaterial.diffuse.wrapT  = SCNWrapModeRepeat;
    
    _mercuryNodeL.geometry.firstMaterial.locksAmbientWithDiffuse =
    _venusNodeL.geometry.firstMaterial.locksAmbientWithDiffuse =
    _marsNodeL.geometry.firstMaterial.locksAmbientWithDiffuse =
    _earthNodeL.geometry.firstMaterial.locksAmbientWithDiffuse =
    _moonNodeL.geometry.firstMaterial.locksAmbientWithDiffuse  =
    _jupiterNodeL.geometry.firstMaterial.locksAmbientWithDiffuse  =
    _saturnNodeL.geometry.firstMaterial.locksAmbientWithDiffuse  =
    _uranusNodeL.geometry.firstMaterial.locksAmbientWithDiffuse  =
    _neptuneNodeL.geometry.firstMaterial.locksAmbientWithDiffuse  =
    _plutoNodeL.geometry.firstMaterial.locksAmbientWithDiffuse  =
    _sunNodeL.geometry.firstMaterial.locksAmbientWithDiffuse   = YES;
    
    _mercuryNodeL.geometry.firstMaterial.shininess =
    _venusNodeL.geometry.firstMaterial.shininess =
    _earthNodeL.geometry.firstMaterial.shininess =
    _moonNodeL.geometry.firstMaterial.shininess =
    _marsNodeL.geometry.firstMaterial.shininess =
    _jupiterNodeL.geometry.firstMaterial.shininess =
    _saturnNodeL.geometry.firstMaterial.shininess =
    _uranusNodeL.geometry.firstMaterial.shininess =
    _neptuneNodeL.geometry.firstMaterial.shininess =
    _plutoNodeL.geometry.firstMaterial.shininess = 0.1;
    
    _mercuryNodeL.geometry.firstMaterial.specular.intensity =
    _venusNodeL.geometry.firstMaterial.specular.intensity =
    _earthNodeL.geometry.firstMaterial.specular.intensity =
    _moonNodeL.geometry.firstMaterial.specular.intensity =
    _marsNodeL.geometry.firstMaterial.specular.intensity =
    _jupiterNodeL.geometry.firstMaterial.specular.intensity =
    _saturnNodeL.geometry.firstMaterial.specular.intensity =
    _uranusNodeL.geometry.firstMaterial.specular.intensity =
    _neptuneNodeL.geometry.firstMaterial.specular.intensity =
    _plutoNodeL.geometry.firstMaterial.specular.intensity =
    _marsNodeL.geometry.firstMaterial.specular.intensity = 0.5;
    
    _moonNodeL.geometry.firstMaterial.specular.contents = [UIColor grayColor];
    
    [self roationNodeL];
    [self addOtherNodeL];
    [self addLightL];
    
}

- (void)initNodeWithRootView:(SCNView *) scnView{
    
    _sunNode = [SCNNode new];
    _mercuryNode = [SCNNode new];
    _venusNode = [SCNNode new];
    _earthNode = [SCNNode new];
    _moonNode = [SCNNode new];
    _marsNode = [SCNNode new];
    _earthGroupNode = [SCNNode new];
    _jupiterNode = [SCNNode new];
    _saturnNode = [SCNNode new];
    //_saturnLoopNode = [SCNNode new];
    _sartunGruopNode = [SCNNode new];
    _uranusNode = [SCNNode new];
    _neptuneNode = [SCNNode new];
    _plutoNode = [SCNNode new];
    
    _sunNode.geometry = [SCNSphere sphereWithRadius:0.25];
    _mercuryNode.geometry = [SCNSphere sphereWithRadius:0.02];
    _venusNode.geometry = [SCNSphere sphereWithRadius:0.04];
    _marsNode.geometry = [SCNSphere sphereWithRadius:0.03];
    _earthNode.geometry = [SCNSphere sphereWithRadius:0.05];
    _moonNode.geometry = [SCNSphere sphereWithRadius:0.01];
    _jupiterNode.geometry = [SCNSphere sphereWithRadius:0.15];
    _saturnNode.geometry = [SCNSphere sphereWithRadius:0.12];
    _uranusNode.geometry = [SCNSphere sphereWithRadius:0.09];
    _neptuneNode.geometry = [SCNSphere sphereWithRadius:0.08];
    _plutoNode.geometry = [SCNSphere sphereWithRadius:0.04];
    
    _moonNode.position = SCNVector3Make(0.1, 0, 0);
    [_earthGroupNode addChildNode:_earthNode];
    
    [_sartunGruopNode addChildNode:_saturnNode];
    
    //添加土星环
    SCNNode *saturnLoopNode = [SCNNode new];
    saturnLoopNode.opacity = 0.4;
    saturnLoopNode.geometry = [SCNBox boxWithWidth:0.6 height:0 length:0.6 chamferRadius:0];
    saturnLoopNode.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/saturn_loop.png";
    saturnLoopNode.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    saturnLoopNode.rotation = SCNVector4Make(-0.5, -1, 0, M_PI_2);
    saturnLoopNode.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant; // no lighting
    [_sartunGruopNode addChildNode:saturnLoopNode];
    
    _mercuryNode.position = SCNVector3Make(0.4, 0, 0);
    _venusNode.position = SCNVector3Make(0.6, 0, 0);
    _earthGroupNode.position = SCNVector3Make(0.8, 0, 0);
    _marsNode.position = SCNVector3Make(1.0, 0, 0);
    _jupiterNode.position = SCNVector3Make(1.4, 0, 0);
    _sartunGruopNode.position = SCNVector3Make(1.68, 0, 0);
    _uranusNode.position = SCNVector3Make(1.95, 0, 0);
    _neptuneNode.position = SCNVector3Make(2.14, 0, 0);
    _plutoNode.position = SCNVector3Make(2.319, 0, 0);
    
    [_sunNode setPosition:SCNVector3Make(0, -0.1, 3)];
    
    [scnView.scene.rootNode addChildNode:_sunNode];
    
    //水星贴图
    _mercuryNode.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/mercury.jpg";
    //金星贴图
    _venusNode.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/venus.jpg";
    //火星贴图
    _marsNode.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/mars.jpg";
    
    // 地球贴图
    _earthNode.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/earth-diffuse-mini.jpg";
    _earthNode.geometry.firstMaterial.emission.contents = @"art.scnassets/earth/earth-emissive-mini.jpg";
    _earthNode.geometry.firstMaterial.specular.contents = @"art.scnassets/earth/earth-specular-mini.jpg";
    //月球贴图
    _moonNode.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/moon.jpg";
    
    //木星贴图
    _jupiterNode.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/jupiter.jpg";
    //土星贴图
    _saturnNode.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/saturn.jpg";
    _saturnLoopNode.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/saturn_loop.jpg";
    //天王星
    _uranusNode.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/uranus.jpg";
    //海王星
    _neptuneNode.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/neptune.jpg";
    //冥王星
    _plutoNode.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/pluto.jpg";
    
    //太阳贴图
    _sunNode.geometry.firstMaterial.multiply.contents = @"art.scnassets/earth/sun.jpg";
    _sunNode.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/sun.jpg";
    _sunNode.geometry.firstMaterial.multiply.intensity = 0.5;
    _sunNode.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant;
    
    _sunNode.geometry.firstMaterial.multiply.wrapS =
    _sunNode.geometry.firstMaterial.diffuse.wrapS  =
    _sunNode.geometry.firstMaterial.multiply.wrapT =
    _sunNode.geometry.firstMaterial.diffuse.wrapT  = SCNWrapModeRepeat;
    
    _mercuryNode.geometry.firstMaterial.locksAmbientWithDiffuse =
    _venusNode.geometry.firstMaterial.locksAmbientWithDiffuse =
    _marsNode.geometry.firstMaterial.locksAmbientWithDiffuse =
    _earthNode.geometry.firstMaterial.locksAmbientWithDiffuse =
    _moonNode.geometry.firstMaterial.locksAmbientWithDiffuse  =
    _jupiterNode.geometry.firstMaterial.locksAmbientWithDiffuse  =
    _saturnNode.geometry.firstMaterial.locksAmbientWithDiffuse  =
    _uranusNode.geometry.firstMaterial.locksAmbientWithDiffuse  =
    _neptuneNode.geometry.firstMaterial.locksAmbientWithDiffuse  =
    _plutoNode.geometry.firstMaterial.locksAmbientWithDiffuse  =
    _sunNode.geometry.firstMaterial.locksAmbientWithDiffuse   = YES;
    
    _mercuryNode.geometry.firstMaterial.shininess =
    _venusNode.geometry.firstMaterial.shininess =
    _earthNode.geometry.firstMaterial.shininess =
    _moonNode.geometry.firstMaterial.shininess =
    _marsNode.geometry.firstMaterial.shininess =
    _jupiterNode.geometry.firstMaterial.shininess =
    _saturnNode.geometry.firstMaterial.shininess =
    _uranusNode.geometry.firstMaterial.shininess =
    _neptuneNode.geometry.firstMaterial.shininess =
    _plutoNode.geometry.firstMaterial.shininess = 0.1;
    
    _mercuryNode.geometry.firstMaterial.specular.intensity =
    _venusNode.geometry.firstMaterial.specular.intensity =
    _earthNode.geometry.firstMaterial.specular.intensity =
    _moonNode.geometry.firstMaterial.specular.intensity =
    _marsNode.geometry.firstMaterial.specular.intensity =
    _jupiterNode.geometry.firstMaterial.specular.intensity =
    _saturnNode.geometry.firstMaterial.specular.intensity =
    _uranusNode.geometry.firstMaterial.specular.intensity =
    _neptuneNode.geometry.firstMaterial.specular.intensity =
    _plutoNode.geometry.firstMaterial.specular.intensity =
    _marsNode.geometry.firstMaterial.specular.intensity = 0.5;
    
    _moonNode.geometry.firstMaterial.specular.contents = [UIColor grayColor];
    
    [self roationNode];
    [self addOtherNode];
    [self addLight];
    
}

-(void)roationNode{
    
    [_earthNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];   //地球自转
    
    // Rotate the moon
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"rotation"];        //月球自转
    animation.duration = 1.5;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    animation.repeatCount = FLT_MAX;
    [_moonNode addAnimation:animation forKey:@"moon rotation"];
    
    // Moon-rotation (center of rotation of the Moon around the Earth)
    SCNNode *moonRotationNode = [SCNNode node];
    
    [moonRotationNode addChildNode:_moonNode];
    
    // Rotate the moon around the Earth
    CABasicAnimation *moonRotationAnimation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    moonRotationAnimation.duration = 15.0;
    moonRotationAnimation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    moonRotationAnimation.repeatCount = FLT_MAX;
    [moonRotationNode addAnimation:animation forKey:@"moon rotation around earth"];
    
    [_earthGroupNode addChildNode:moonRotationNode];
    
    
    // Earth-rotation (center of rotation of the Earth around the Sun)
    SCNNode *earthRotationNode = [SCNNode node];
    [_sunNode addChildNode:earthRotationNode];
    
    // Earth-group (will contain the Earth, and the Moon)
    [earthRotationNode addChildNode:_earthGroupNode];
    
    // Rotate the Earth around the Sun
    animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    animation.duration = 30.0;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    animation.repeatCount = FLT_MAX;
    [earthRotationNode addAnimation:animation forKey:@"earth rotation around sun"];
    
    [_mercuryNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    [_venusNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    [_marsNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    [_jupiterNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    [_saturnNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    [_uranusNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    [_neptuneNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    [_plutoNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    
    [_sartunGruopNode addChildNode:_saturnNode];
    
    SCNNode *mercRotationNode = [SCNNode node];
    [mercRotationNode addChildNode:_mercuryNode];
    [_sunNode addChildNode:mercRotationNode];
    
    SCNNode *venusRotationNode = [SCNNode node];
    [venusRotationNode addChildNode:_venusNode];
    [_sunNode addChildNode:venusRotationNode];
    
    SCNNode *marsRotationNode = [SCNNode node];
    [marsRotationNode addChildNode:_marsNode];
    [_sunNode addChildNode:marsRotationNode];
    
    SCNNode *jupiterRotationNode = [SCNNode node];
    [jupiterRotationNode addChildNode:_jupiterNode];
    [_sunNode addChildNode:jupiterRotationNode];
    
    SCNNode *saturnRotationNode = [SCNNode node];
    [saturnRotationNode addChildNode:_sartunGruopNode];
    [_sunNode addChildNode:saturnRotationNode];
    
    SCNNode *uranusRotationNode = [SCNNode node];
    [uranusRotationNode addChildNode:_uranusNode];
    [_sunNode addChildNode:uranusRotationNode];
    
    SCNNode *neptuneRotationNode = [SCNNode node];
    [neptuneRotationNode addChildNode:_neptuneNode];
    [_sunNode addChildNode:neptuneRotationNode];
    
    SCNNode *plutoRotationNode = [SCNNode node];
    [plutoRotationNode addChildNode:_plutoNode];
    [_sunNode addChildNode:plutoRotationNode];
    
    // Rotate the Mercury around the Sun
    animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    animation.duration = 25.0;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    animation.repeatCount = FLT_MAX;
    [mercRotationNode addAnimation:animation forKey:@"mercury rotation around sun"];
    [_sunNode addChildNode:mercRotationNode];
    
    // Rotate the Venus around the Sun
    animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    animation.duration = 40.0;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    animation.repeatCount = FLT_MAX;
    [venusRotationNode addAnimation:animation forKey:@"venus rotation around sun"];
    [_sunNode addChildNode:venusRotationNode];
    
    // Rotate the Mars around the Sun
    animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    animation.duration = 35.0;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    animation.repeatCount = FLT_MAX;
    [marsRotationNode addAnimation:animation forKey:@"mars rotation around sun"];
    [_sunNode addChildNode:marsRotationNode];
    
    // Rotate the Jupiter around the Sun
    animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    animation.duration = 90.0;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    animation.repeatCount = FLT_MAX;
    [jupiterRotationNode addAnimation:animation forKey:@"jupiter rotation around sun"];
    [_sunNode addChildNode:jupiterRotationNode];
    
    // Rotate the Saturn around the Sun
    animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    animation.duration = 80.0;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    animation.repeatCount = FLT_MAX;
    [saturnRotationNode addAnimation:animation forKey:@"mars rotation around sun"];
    [_sunNode addChildNode:saturnRotationNode];
    
    // Rotate the uranus around the Sun
    animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    animation.duration = 55.0;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    animation.repeatCount = FLT_MAX;
    [uranusRotationNode addAnimation:animation forKey:@"mars rotation around sun"];
    [_sunNode addChildNode:uranusRotationNode];
    
    // Rotate the Neptune around the Sun
    animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    animation.duration = 50.0;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    animation.repeatCount = FLT_MAX;
    [neptuneRotationNode addAnimation:animation forKey:@"mars rotation around sun"];
    [_sunNode addChildNode:neptuneRotationNode];
    
    // Rotate the Pluto around the Sun
    animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    animation.duration = 100.0;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    animation.repeatCount = FLT_MAX;
    [plutoRotationNode addAnimation:animation forKey:@"mars rotation around sun"];
    [_sunNode addChildNode:plutoRotationNode];
    
    [self addAnimationToSun];
}

-(void)addAnimationToSun{
    
    // Achieve a lava effect by animating textures
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"contentsTransform"];
    animation.duration = 10.0;
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(0, 0, 0), CATransform3DMakeScale(3, 3, 3))];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(1, 0, 0), CATransform3DMakeScale(3, 3, 3))];
    animation.repeatCount = FLT_MAX;
    [_sunNode.geometry.firstMaterial.diffuse addAnimation:animation forKey:@"sun-texture"];
    
    animation = [CABasicAnimation animationWithKeyPath:@"contentsTransform"];
    animation.duration = 30.0;
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(0, 0, 0), CATransform3DMakeScale(5, 5, 5))];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(1, 0, 0), CATransform3DMakeScale(5, 5, 5))];
    animation.repeatCount = FLT_MAX;
    [_sunNode.geometry.firstMaterial.multiply addAnimation:animation forKey:@"sun-texture2"];
    
}

-(void)roationNodeL {
    
    [_earthNodeL runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];   //地球自转
    
    // Rotate the moon
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"rotation"];        //月球自转
    animation.duration = 1.5;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    animation.repeatCount = FLT_MAX;
    [_moonNodeL addAnimation:animation forKey:@"moon rotation"];
    
    // Moon-rotation (center of rotation of the Moon around the Earth)
    SCNNode *moonRotationNode = [SCNNode node];
    
    [moonRotationNode addChildNode:_moonNodeL];
    
    // Rotate the moon around the Earth
    CABasicAnimation *moonRotationAnimation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    moonRotationAnimation.duration = 15.0;
    moonRotationAnimation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    moonRotationAnimation.repeatCount = FLT_MAX;
    [moonRotationNode addAnimation:animation forKey:@"moon rotation around earth"];
    
    [_earthGroupNodeL addChildNode:moonRotationNode];
    
    
    // Earth-rotation (center of rotation of the Earth around the Sun)
    SCNNode *earthRotationNode = [SCNNode node];
    [_sunNodeL addChildNode:earthRotationNode];
    
    // Earth-group (will contain the Earth, and the Moon)
    [earthRotationNode addChildNode:_earthGroupNodeL];
    
    // Rotate the Earth around the Sun
    animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    animation.duration = 30.0;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    animation.repeatCount = FLT_MAX;
    [earthRotationNode addAnimation:animation forKey:@"earth rotation around sun"];
    
    [_mercuryNodeL runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    [_venusNodeL runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    [_marsNodeL runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    [_jupiterNodeL runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    [_saturnNodeL runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    [_uranusNodeL runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    [_neptuneNodeL runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    [_plutoNodeL runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    
    [_sartunGruopNodeL addChildNode:_saturnNodeL];
    
    SCNNode *mercRotationNode = [SCNNode node];
    [mercRotationNode addChildNode:_mercuryNodeL];
    [_sunNodeL addChildNode:mercRotationNode];
    
    SCNNode *venusRotationNode = [SCNNode node];
    [venusRotationNode addChildNode:_venusNodeL];
    [_sunNodeL addChildNode:venusRotationNode];
    
    SCNNode *marsRotationNode = [SCNNode node];
    [marsRotationNode addChildNode:_marsNodeL];
    [_sunNodeL addChildNode:marsRotationNode];
    
    SCNNode *jupiterRotationNode = [SCNNode node];
    [jupiterRotationNode addChildNode:_jupiterNodeL];
    [_sunNodeL addChildNode:jupiterRotationNode];
    
    SCNNode *saturnRotationNode = [SCNNode node];
    [saturnRotationNode addChildNode:_sartunGruopNodeL];
    [_sunNodeL addChildNode:saturnRotationNode];
    
    SCNNode *uranusRotationNode = [SCNNode node];
    [uranusRotationNode addChildNode:_uranusNodeL];
    [_sunNodeL addChildNode:uranusRotationNode];
    
    SCNNode *neptuneRotationNode = [SCNNode node];
    [neptuneRotationNode addChildNode:_neptuneNodeL];
    [_sunNodeL addChildNode:neptuneRotationNode];
    
    SCNNode *plutoRotationNode = [SCNNode node];
    [plutoRotationNode addChildNode:_plutoNodeL];
    [_sunNodeL addChildNode:plutoRotationNode];
    
    // Rotate the Mercury around the Sun
    animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    animation.duration = 25.0;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    animation.repeatCount = FLT_MAX;
    [mercRotationNode addAnimation:animation forKey:@"mercury rotation around sun"];
    [_sunNodeL addChildNode:mercRotationNode];
    
    // Rotate the Venus around the Sun
    animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    animation.duration = 40.0;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    animation.repeatCount = FLT_MAX;
    [venusRotationNode addAnimation:animation forKey:@"venus rotation around sun"];
    [_sunNodeL addChildNode:venusRotationNode];
    
    // Rotate the Mars around the Sun
    animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    animation.duration = 35.0;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    animation.repeatCount = FLT_MAX;
    [marsRotationNode addAnimation:animation forKey:@"mars rotation around sun"];
    [_sunNodeL addChildNode:marsRotationNode];
    
    // Rotate the Jupiter around the Sun
    animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    animation.duration = 90.0;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    animation.repeatCount = FLT_MAX;
    [jupiterRotationNode addAnimation:animation forKey:@"jupiter rotation around sun"];
    [_sunNodeL addChildNode:jupiterRotationNode];
    
    // Rotate the Saturn around the Sun
    animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    animation.duration = 80.0;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    animation.repeatCount = FLT_MAX;
    [saturnRotationNode addAnimation:animation forKey:@"mars rotation around sun"];
    [_sunNodeL addChildNode:saturnRotationNode];
    
    // Rotate the uranus around the Sun
    animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    animation.duration = 55.0;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    animation.repeatCount = FLT_MAX;
    [uranusRotationNode addAnimation:animation forKey:@"mars rotation around sun"];
    [_sunNodeL addChildNode:uranusRotationNode];
    
    // Rotate the Neptune around the Sun
    animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    animation.duration = 50.0;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    animation.repeatCount = FLT_MAX;
    [neptuneRotationNode addAnimation:animation forKey:@"mars rotation around sun"];
    [_sunNodeL addChildNode:neptuneRotationNode];
    
    // Rotate the Pluto around the Sun
    animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    animation.duration = 100.0;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    animation.repeatCount = FLT_MAX;
    [plutoRotationNode addAnimation:animation forKey:@"mars rotation around sun"];
    [_sunNodeL addChildNode:plutoRotationNode];
    
    [self addAnimationToSunL];
}

-(void)addAnimationToSunL{
    
    // Achieve a lava effect by animating textures
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"contentsTransform"];
    animation.duration = 10.0;
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(0, 0, 0), CATransform3DMakeScale(3, 3, 3))];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(1, 0, 0), CATransform3DMakeScale(3, 3, 3))];
    animation.repeatCount = FLT_MAX;
    [_sunNodeL.geometry.firstMaterial.diffuse addAnimation:animation forKey:@"sun-texture"];
    
    animation = [CABasicAnimation animationWithKeyPath:@"contentsTransform"];
    animation.duration = 30.0;
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(0, 0, 0), CATransform3DMakeScale(5, 5, 5))];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(1, 0, 0), CATransform3DMakeScale(5, 5, 5))];
    animation.repeatCount = FLT_MAX;
    [_sunNodeL.geometry.firstMaterial.multiply addAnimation:animation forKey:@"sun-texture2"];
    
}


-(void)mathRoation{
    
    // 相关数学知识点： 任意点a(x,y)，绕一个坐标点b(rx0,ry0)逆时针旋转a角度后的新的坐标设为c(x0, y0)，有公式：
    
    //    x0= (x - rx0)*cos(a) - (y - ry0)*sin(a) + rx0 ;
    //
    //    y0= (x - rx0)*sin(a) + (y - ry0)*cos(a) + ry0 ;
    
    // custom Action
    
    float totalDuration = 10.0f;        //10s 围绕地球转一圈
    float duration = totalDuration/360;  //每隔duration秒去执行一次
    
    
    SCNAction *customAction = [SCNAction customActionWithDuration:duration actionBlock:^(SCNNode * _Nonnull node, CGFloat elapsedTime){
        
        
        if(elapsedTime == duration){
            
            
            SCNVector3 position = node.position;
            
            float rx0 = 0;    //原点为0
            float ry0 = 0;
            
            float angle = 1.0f/180*M_PI;
            
            float x =  (position.x - rx0)*cos(angle) - (position.z - ry0)*sin(angle) + rx0 ;
            
            float z = (position.x - rx0)*sin(angle) + (position.z - ry0)*cos(angle) + ry0 ;
            
            node.position = SCNVector3Make(x, node.position.y, z);
            
        }
        
    }];
    
    SCNAction *repeatAction = [SCNAction repeatActionForever:customAction];
    
    [_earthGroupNode runAction:repeatAction];
}

-(void)addLight{
    
    // We will turn off all the lights in the scene and add a new light
    // to give the impression that the Sun lights the scene
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.color = [UIColor blackColor]; // initially switched off
    lightNode.light.type = SCNLightTypeOmni;
    [_sunNode addChildNode:lightNode];
    
    // Configure attenuation distances because we don't want to light the floor
    lightNode.light.attenuationEndDistance = 19;
    lightNode.light.attenuationStartDistance = 21;
    
    // Animation
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:1];
    {
        lightNode.light.color = [UIColor whiteColor]; // switch on
        //[presentationViewController updateLightingWithIntensities:@[@0.0]]; //switch off all the other lights
        _sunHaloNode.opacity = 0.5; // make the halo stronger
    }
    [SCNTransaction commit];
    
}

- (void)addOtherNode{
    
    SCNNode *cloudsNode = [SCNNode node];
    cloudsNode.geometry = [SCNSphere sphereWithRadius:0.06];
    [_earthNode addChildNode:cloudsNode];
    
    cloudsNode.opacity = 0.5;
    // This effect can also be achieved with an image with some transparency set as the contents of the 'diffuse' property
    cloudsNode.geometry.firstMaterial.transparent.contents = @"art.scnassets/earth/cloudsTransparency.png";
    cloudsNode.geometry.firstMaterial.transparencyMode = SCNTransparencyModeRGBZero;
    
    // Add a halo to the Sun (a simple textured plane that does not write to depth)
    _sunHaloNode = [SCNNode node];
    _sunHaloNode.geometry = [SCNPlane planeWithWidth:2.5 height:2.5];
    _sunHaloNode.rotation = SCNVector4Make(1, 0, 0, 0 * M_PI / 180.0);
    _sunHaloNode.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/sun-halo.png";
    _sunHaloNode.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant; // no lighting
    _sunHaloNode.geometry.firstMaterial.writesToDepthBuffer = NO; // do not write to depth
    _sunHaloNode.opacity = 0.2;
    [_sunNode addChildNode:_sunHaloNode];
    
    // Add a textured plane to represent mercury's orbit
    SCNNode *mercuryOrbit = [SCNNode node];
    mercuryOrbit.opacity = 0.4;
    mercuryOrbit.geometry = [SCNBox boxWithWidth:0.86 height:0 length:0.86 chamferRadius:0];
    mercuryOrbit.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/orbit.png";
    mercuryOrbit.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    mercuryOrbit.rotation = SCNVector4Make(0, 1, 0, M_PI_2);
    mercuryOrbit.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant; // no lighting
    [_sunNode addChildNode:mercuryOrbit];
    
    // Add a textured plane to represent venus's orbit
    SCNNode *venusOrbit = [SCNNode node];
    venusOrbit.opacity = 0.4;
    venusOrbit.geometry = [SCNBox boxWithWidth:1.29 height:0 length:1.29 chamferRadius:0];
    venusOrbit.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/orbit.png";
    venusOrbit.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    venusOrbit.rotation = SCNVector4Make(0, 1, 0, M_PI_2);
    venusOrbit.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant; // no lighting
    [_sunNode addChildNode:venusOrbit];
    
    // Add a textured plane to represent Earth's orbit
    SCNNode *earthOrbit = [SCNNode node];
    earthOrbit.opacity = 0.4;
    earthOrbit.geometry = [SCNBox boxWithWidth:1.72 height:0 length:1.72 chamferRadius:0];
    earthOrbit.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/orbit.png";
    earthOrbit.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    earthOrbit.rotation = SCNVector4Make(0, 1, 0, M_PI_2);
    earthOrbit.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant; // no lighting
    [_sunNode addChildNode:earthOrbit];
    
    // Add a textured plane to represent mars's orbit
    SCNNode *marsOrbit = [SCNNode node];
    marsOrbit.opacity = 0.4;
    marsOrbit.geometry = [SCNBox boxWithWidth:2.14 height:0 length:2.14 chamferRadius:0];
    marsOrbit.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/orbit.png";
    marsOrbit.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    marsOrbit.rotation = SCNVector4Make(0, 1, 0, M_PI_2);
    marsOrbit.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant; // no lighting
    [_sunNode addChildNode:marsOrbit];
    
    // Add a textured plane to represent jupiter's orbit
    SCNNode *jupiterOrbit = [SCNNode node];
    jupiterOrbit.opacity = 0.4;
    jupiterOrbit.geometry = [SCNBox boxWithWidth:2.95 height:0 length:2.95 chamferRadius:0];
    jupiterOrbit.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/orbit.png";
    jupiterOrbit.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    jupiterOrbit.rotation = SCNVector4Make(0, 1, 0, M_PI_2);
    jupiterOrbit.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant; // no lighting
    [_sunNode addChildNode:jupiterOrbit];
    
    // Add a textured plane to represent saturn's orbit
    SCNNode *saturnOrbit = [SCNNode node];
    saturnOrbit.opacity = 0.4;
    saturnOrbit.geometry = [SCNBox boxWithWidth:3.57 height:0 length:3.57 chamferRadius:0];
    saturnOrbit.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/orbit.png";
    saturnOrbit.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    saturnOrbit.rotation = SCNVector4Make(0, 1, 0, M_PI_2);
    saturnOrbit.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant; // no lighting
    [_sunNode addChildNode:saturnOrbit];
    
    // Add a textured plane to represent uranus's orbit
    SCNNode *uranusOrbit = [SCNNode node];
    uranusOrbit.opacity = 0.4;
    uranusOrbit.geometry = [SCNBox boxWithWidth:4.19 height:0 length:4.19 chamferRadius:0];
    uranusOrbit.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/orbit.png";
    uranusOrbit.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    uranusOrbit.rotation = SCNVector4Make(0, 1, 0, M_PI_2);
    uranusOrbit.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant; // no lighting
    [_sunNode addChildNode:uranusOrbit];
    
    // Add a textured plane to represent neptune's orbit
    SCNNode *neptuneOrbit = [SCNNode node];
    neptuneOrbit.opacity = 0.4;
    neptuneOrbit.geometry = [SCNBox boxWithWidth:4.54 height:0 length:4.54 chamferRadius:0];
    neptuneOrbit.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/orbit.png";
    neptuneOrbit.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    neptuneOrbit.rotation = SCNVector4Make(0, 1, 0, M_PI_2);
    neptuneOrbit.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant; // no lighting
    [_sunNode addChildNode:neptuneOrbit];
    
    // Add a textured plane to represent plute's orbit
    SCNNode *pluteOrbit = [SCNNode node];
    pluteOrbit.opacity = 0.4;
    pluteOrbit.geometry = [SCNBox boxWithWidth:4.98 height:0 length:4.98 chamferRadius:0];
    pluteOrbit.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/orbit.png";
    pluteOrbit.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    pluteOrbit.rotation = SCNVector4Make(0, 1, 0, M_PI_2);
    pluteOrbit.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant; // no lighting
    [_sunNode addChildNode:pluteOrbit];
    
    
}

-(void)addLightL{
    
    // We will turn off all the lights in the scene and add a new light
    // to give the impression that the Sun lights the scene
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.color = [UIColor blackColor]; // initially switched off
    lightNode.light.type = SCNLightTypeOmni;
    [_sunNodeL addChildNode:lightNode];
    
    // Configure attenuation distances because we don't want to light the floor
    lightNode.light.attenuationEndDistance = 19;
    lightNode.light.attenuationStartDistance = 21;
    
    // Animation
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:1];
    {
        lightNode.light.color = [UIColor whiteColor]; // switch on
        //[presentationViewController updateLightingWithIntensities:@[@0.0]]; //switch off all the other lights
        _sunHaloNodeL.opacity = 0.5; // make the halo stronger
    }
    [SCNTransaction commit];
    
}

- (void)addOtherNodeL{
    
    SCNNode *cloudsNode = [SCNNode node];
    cloudsNode.geometry = [SCNSphere sphereWithRadius:0.06];
    [_earthNodeL addChildNode:cloudsNode];
    
    cloudsNode.opacity = 0.5;
    // This effect can also be achieved with an image with some transparency set as the contents of the 'diffuse' property
    cloudsNode.geometry.firstMaterial.transparent.contents = @"art.scnassets/earth/cloudsTransparency.png";
    cloudsNode.geometry.firstMaterial.transparencyMode = SCNTransparencyModeRGBZero;
    
    // Add a halo to the Sun (a simple textured plane that does not write to depth)
    _sunHaloNodeL = [SCNNode node];
    _sunHaloNodeL.geometry = [SCNPlane planeWithWidth:2.5 height:2.5];
    _sunHaloNodeL.rotation = SCNVector4Make(1, 0, 0, 0 * M_PI / 180.0);
    _sunHaloNodeL.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/sun-halo.png";
    _sunHaloNodeL.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant; // no lighting
    _sunHaloNodeL.geometry.firstMaterial.writesToDepthBuffer = NO; // do not write to depth
    _sunHaloNodeL.opacity = 0.2;
    [_sunNodeL addChildNode:_sunHaloNodeL];
    
    // Add a textured plane to represent mercury's orbit
    SCNNode *mercuryOrbit = [SCNNode node];
    mercuryOrbit.opacity = 0.4;
    mercuryOrbit.geometry = [SCNBox boxWithWidth:0.86 height:0 length:0.86 chamferRadius:0];
    mercuryOrbit.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/orbit.png";
    mercuryOrbit.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    mercuryOrbit.rotation = SCNVector4Make(0, 1, 0, M_PI_2);
    mercuryOrbit.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant; // no lighting
    [_sunNodeL addChildNode:mercuryOrbit];
    
    // Add a textured plane to represent venus's orbit
    SCNNode *venusOrbit = [SCNNode node];
    venusOrbit.opacity = 0.4;
    venusOrbit.geometry = [SCNBox boxWithWidth:1.29 height:0 length:1.29 chamferRadius:0];
    venusOrbit.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/orbit.png";
    venusOrbit.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    venusOrbit.rotation = SCNVector4Make(0, 1, 0, M_PI_2);
    venusOrbit.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant; // no lighting
    [_sunNodeL addChildNode:venusOrbit];
    
    // Add a textured plane to represent Earth's orbit
    SCNNode *earthOrbit = [SCNNode node];
    earthOrbit.opacity = 0.4;
    earthOrbit.geometry = [SCNBox boxWithWidth:1.72 height:0 length:1.72 chamferRadius:0];
    earthOrbit.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/orbit.png";
    earthOrbit.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    earthOrbit.rotation = SCNVector4Make(0, 1, 0, M_PI_2);
    earthOrbit.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant; // no lighting
    [_sunNodeL addChildNode:earthOrbit];
    
    // Add a textured plane to represent mars's orbit
    SCNNode *marsOrbit = [SCNNode node];
    marsOrbit.opacity = 0.4;
    marsOrbit.geometry = [SCNBox boxWithWidth:2.14 height:0 length:2.14 chamferRadius:0];
    marsOrbit.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/orbit.png";
    marsOrbit.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    marsOrbit.rotation = SCNVector4Make(0, 1, 0, M_PI_2);
    marsOrbit.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant; // no lighting
    [_sunNodeL addChildNode:marsOrbit];
    
    // Add a textured plane to represent jupiter's orbit
    SCNNode *jupiterOrbit = [SCNNode node];
    jupiterOrbit.opacity = 0.4;
    jupiterOrbit.geometry = [SCNBox boxWithWidth:2.95 height:0 length:2.95 chamferRadius:0];
    jupiterOrbit.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/orbit.png";
    jupiterOrbit.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    jupiterOrbit.rotation = SCNVector4Make(0, 1, 0, M_PI_2);
    jupiterOrbit.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant; // no lighting
    [_sunNodeL addChildNode:jupiterOrbit];
    
    // Add a textured plane to represent saturn's orbit
    SCNNode *saturnOrbit = [SCNNode node];
    saturnOrbit.opacity = 0.4;
    saturnOrbit.geometry = [SCNBox boxWithWidth:3.57 height:0 length:3.57 chamferRadius:0];
    saturnOrbit.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/orbit.png";
    saturnOrbit.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    saturnOrbit.rotation = SCNVector4Make(0, 1, 0, M_PI_2);
    saturnOrbit.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant; // no lighting
    [_sunNodeL addChildNode:saturnOrbit];
    
    // Add a textured plane to represent uranus's orbit
    SCNNode *uranusOrbit = [SCNNode node];
    uranusOrbit.opacity = 0.4;
    uranusOrbit.geometry = [SCNBox boxWithWidth:4.19 height:0 length:4.19 chamferRadius:0];
    uranusOrbit.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/orbit.png";
    uranusOrbit.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    uranusOrbit.rotation = SCNVector4Make(0, 1, 0, M_PI_2);
    uranusOrbit.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant; // no lighting
    [_sunNodeL addChildNode:uranusOrbit];
    
    // Add a textured plane to represent neptune's orbit
    SCNNode *neptuneOrbit = [SCNNode node];
    neptuneOrbit.opacity = 0.4;
    neptuneOrbit.geometry = [SCNBox boxWithWidth:4.54 height:0 length:4.54 chamferRadius:0];
    neptuneOrbit.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/orbit.png";
    neptuneOrbit.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    neptuneOrbit.rotation = SCNVector4Make(0, 1, 0, M_PI_2);
    neptuneOrbit.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant; // no lighting
    [_sunNodeL addChildNode:neptuneOrbit];
    
    // Add a textured plane to represent plute's orbit
    SCNNode *pluteOrbit = [SCNNode node];
    pluteOrbit.opacity = 0.4;
    pluteOrbit.geometry = [SCNBox boxWithWidth:4.98 height:0 length:4.98 chamferRadius:0];
    pluteOrbit.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/orbit.png";
    pluteOrbit.geometry.firstMaterial.diffuse.mipFilter = SCNFilterModeLinear;
    pluteOrbit.rotation = SCNVector4Make(0, 1, 0, M_PI_2);
    pluteOrbit.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant; // no lighting
    [_sunNodeL addChildNode:pluteOrbit];
    
    
}

- (ARWorldTrackingConfiguration *)arSessionConfiguration
{
    if (_arSessionConfiguration != nil) {
        return _arSessionConfiguration;
    }
    
    //1.创建世界追踪会话配置（使用ARWorldTrackingSessionConfiguration效果更加好），需要A9芯片支持
    ARWorldTrackingConfiguration *configuration = [[ARWorldTrackingConfiguration alloc] init];
    //2.设置追踪方向（追踪平面，后面会用到）
    configuration.planeDetection = ARPlaneDetectionHorizontal;
    _arSessionConfiguration = configuration;
    //3.自适应灯光（相机从暗到强光快速过渡效果会平缓一些）
    _arSessionConfiguration.lightEstimationEnabled = YES;
    return _arSessionConfiguration;
}

- (ARSession *)arSession
{
    if(_arSession != nil)
    {
        return _arSession;
    }
    _arSession = [[ARSession alloc] init];
    _arSession.delegate = self;
    return _arSession;
}

- (ARSCNView *)arLeftView {
    
    if (!_arLeftView) {
        
        _arLeftView = [[ARSCNView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 0.5 * screenHeight)];
        _arLeftView.session = self.arSession;
        _arLeftView.automaticallyUpdatesLighting = YES;
        _arLeftView.delegate = self;
    }
    return _arLeftView;
}

- (ARSCNView *)arRightView {
    
    if (!_arRightView) {
        _arRightView = [[ARSCNView alloc] initWithFrame:CGRectMake(
           0,
           (!_isCardBoard ? 0 : 0.5) * screenHeight,
           screenWidth,
           (!_isCardBoard ? 1.0 : 0.5) * screenHeight)];
        _arRightView.session = self.arSession;
        _arRightView.automaticallyUpdatesLighting = YES;
        _arRightView.delegate = self;
    }
    return _arRightView;
}

- (void)initNode {
    
    addedNode = YES;
    //初始化左右视图节点
    if (_isCardBoard)
        [self initWithLeftNode:_arLeftView];
    [self initNodeWithRootView:_arRightView];
}

- (ARSCNView *)arSCNView
{
    if (_arSCNView != nil) {
        return _arSCNView;
    }
    _arSCNView = [[ARSCNView alloc] initWithFrame:self.view.bounds];
    _arSCNView.session = self.arSession;
    _arSCNView.automaticallyUpdatesLighting = YES;
    _arSCNView.delegate = self;
    
    //初始化节点
    [self initNodeWithRootView:_arSCNView];
    
    return _arSCNView;
}

#pragma mark -ARSessionDelegate
//会话位置更新
- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame
{
    //监听手机的移动，实现近距离查看太阳系细节，为了凸显效果变化值*3
    [_sunNode setPosition:SCNVector3Make(-3 * frame.camera.transform.columns[3].x, -0.1 - 3 * frame.camera.transform.columns[3].y, -2 - 3 * frame.camera.transform.columns[3].z)];
    [_sunNodeL setPosition:SCNVector3Make(-3 * frame.camera.transform.columns[3].x, -0.1 - 3 * frame.camera.transform.columns[3].y, -2 - 3 * frame.camera.transform.columns[3].z)];
}

- (void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor
{
    NSLog(@"找到了新的平面");
//    if (!addedNode) {
//        [self initNode];
//    }
}
@end


