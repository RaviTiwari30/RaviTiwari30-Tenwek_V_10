<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Ot_Anes_Procedure.aspx.cs" Inherits="Design_OT_Ot_Anes_Procedure" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
    <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="../../Scripts/ipad.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/CPOE_AddToFavorites.js"></script>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <script src="../../Scripts/chosen.jquery.min.js"></script>
    <link href="../../Styles/chosen.css" rel="stylesheet" />
    <script type="text/javascript">
        var togglePatientDetailSection = function (el, isForceHide) {
            var x = $(el).parent().find('.row:first');
            if (x.css('display') == 'block') {
                x.css('display', 'none');
            } else {
                x.css('display', 'block');
            }
        }

    </script>


    <style>
        .ClassMTop {
            margin-top: -5px;
            margin-left: -40px;
        }

        .ClassMBold {
        }

        .ClassMBold1 {
            font-weight: bold;
        }

        .ClassHeading {
            font-size: 20px;
            text-align: center;
            font-weight: bold;
        }

        .ClassSubHeading {
            margin-top: 10px;
            margin-bottom: 10px;
            font-size: 16px;
            font-weight: bold;
        }

        .ClassSubHeading1 {
            font-size: 16px;
            font-weight: bold;
        }

        .ClassNormalform {
            margin-left: 20px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <asp:ScriptManager ID="ScriptManager" runat="server">
            </asp:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center">
                <div class="ClassHeading" style="text-align: center">
                    <b>Procedures</b>
                </div>
                <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />
            </div>
            <div class="POuter_Box_Inventory">

                <div class="row">

                    <div class="col-md-24 ">

                        <div class="POuter_Box_Inventory">
                            <div class="col-md-24 ClassHeading">
                                Anaesthetic Technique

                            </div>
                            <div class="row">
                                <div class="col-md-3 ClassMBold">
                                    Sedation :
                                </div>
                                <div class="col-md-5 ">
                                    <asp:CheckBox runat="server" ID="chkSedation" class="ClassMTop" />
                                </div>
                                <div class="col-md-3 ClassMBold">
                                    GA :
                                </div>
                                <div class="col-md-5 ">
                                    <asp:CheckBox runat="server" ID="chkGA" class="ClassMTop" />

                                </div>
                                <div class="col-md-3 ClassMBold">
                                    TIVA :
                                </div>
                                <div class="col-md-5 ">
                                    <asp:CheckBox runat="server" ID="chkTIVA" class="ClassMTop" />
                                </div>

                            </div>

                            <div class="row">
                                <div class="col-md-3 ClassMBold">
                                    Spinal :
                                </div>
                                <div class="col-md-5 ">
                                    <asp:CheckBox runat="server" ID="chkSpinal" class="ClassMTop" />
                                </div>
                                <div class="col-md-3 ClassMBold">
                                    Epidural :
                                </div>
                                <div class="col-md-5 ">
                                    <asp:CheckBox runat="server" ID="chkEpidural" class="ClassMTop" />
                                </div>
                                <div class="col-md-3 ClassMBold">
                                    Caudal  :
                              
                                </div>
                                <div class="col-md-5 ">
                                    <asp:CheckBox runat="server" ID="chkCaudal" class="ClassMTop" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-3 ClassMBold">
                                    LA  :
                              
                                </div>
                                <div class="col-md-5 ">
                                    <asp:CheckBox runat="server" ID="chkLA" class="ClassMTop" />
                                </div>

                                <div class="col-md-4 ClassMBold">
                                    Position for operation  :
                              
                                </div>
                                <div class="col-md-12 ">
                                    <asp:TextBox ID="txtPositionforoperation" runat="server"></asp:TextBox>
                                </div>
                                <div class="col-md-15 ClassSubHeading">
                                    Intubation
                                </div>
                                <div class="col-md-9 ClassSubHeading">
                                    Ventilation

                                </div>
                                <div class="row">
                                    <div class="col-md-3 ClassMBold">
                                        ET Tube :
                                    </div>
                                    <div class="col-md-5 ">
                                        <asp:CheckBox runat="server" ID="chkEtTube" class="ClassMTop" />
                                    </div>
                                    <div class="col-md-2 ClassMBold">
                                        Size :
                                    </div>
                                    <div class="col-md-6 ">
                                        <asp:TextBox ID="txtSize" runat="server"></asp:TextBox>
                                    </div>
                                    <div class="col-md-3 ClassMBold">
                                        SV :
                                    </div>
                                    <div class="col-md-5 ">
                                        <asp:CheckBox runat="server" ID="chkSV" class="ClassMTop" />
                                    </div>

                                </div>

                                <div class="row">
                                    <div class="col-md-3 ClassMBold">
                                        Oral :
                                    </div>
                                    <div class="col-md-5 ">
                                        <asp:CheckBox runat="server" ID="chkOral" class="ClassMTop" />
                                    </div>
                                    <div class="col-md-3 ClassMBold">
                                        Cuff :
                                    </div>
                                    <div class="col-md-5 ">
                                        <asp:CheckBox runat="server" ID="chkCuff" class="ClassMTop" />

                                    </div>
                                    <div class="col-md-3 ClassMBold">
                                        IPPV :
                                    </div>
                                    <div class="col-md-5 ">
                                        <asp:CheckBox runat="server" ID="chkIPPV" class="ClassMTop" />
                                    </div>

                                </div>

                                <div class="row">
                                    <div class="col-md-3 ClassMBold">
                                        Nasal

                                    </div>
                                    <div class="col-md-5 ">
                                        <asp:CheckBox runat="server" ID="chkNasal" class="ClassMTop" />
                                    </div>
                                    <div class="col-md-3 ClassMBold">
                                    </div>
                                    <div class="col-md-5 ">
                                    </div>
                                    <div class="col-md-3 ClassMBold">
                                        VT :
                                    </div>
                                    <div class="col-md-5 ">
                                        <asp:CheckBox runat="server" ID="chkVT" class="ClassMTop" />
                                        <asp:TextBox runat="server" ID="txtVT" TextMode="MultiLine"></asp:TextBox>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-3 ClassMBold">
                                        Throat Pack :

                                    </div>
                                    <div class="col-md-5 ">
                                        <asp:CheckBox runat="server" ID="chkThroatPack" class="ClassMTop" />
                                    </div>
                                    <div class="col-md-3 ClassMBold">
                                    </div>
                                    <div class="col-md-5 ">
                                    </div>
                                    <div class="col-md-3 ClassMBold">
                                        RR :
                                    </div>
                                    <div class="col-md-5 ">
                                        <asp:TextBox runat="server" ID="txtRR"></asp:TextBox>
                                    </div>

                                </div>

                                <div class="row">
                                    <div class="col-md-3 ClassMBold">
                                        Easy
:
                                    </div>
                                    <div class="col-md-5 ">
                                        <asp:CheckBox runat="server" ID="chkEasy" class="ClassMTop" />
                                    </div>
                                    <div class="col-md-3 ClassMBold">
                                    </div>
                                    <div class="col-md-5 ">
                                    </div>
                                    <div class="col-md-3 ClassMBold">
                                        Circuit :
                                    </div>
                                    <div class="col-md-5 ">
                                        <asp:TextBox runat="server" ID="txtCircuit" TextMode="MultiLine"></asp:TextBox>
                                    </div>


                                </div>

                                <div class="row">
                                    <div class="col-md-3 ClassMBold">
                                        Difficult

                                    </div>
                                    <div class="col-md-5 ">
                                        <asp:CheckBox runat="server" ID="chkDifficult" class="ClassMTop" />
                                    </div>
                                    <div class="col-md-3 ClassMBold">
                                    </div>
                                    <div class="col-md-5 ">
                                    </div>
                                    <div class="col-md-3 ClassMBold">
                                    </div>
                                    <div class="col-md-5 ">
                                    </div>

                                </div>

                                <div class="row">
                                    <div class="col-md-3 ClassMBold">
                                        Grade 
:
                                    </div>
                                    <div class="col-md-2 ">
                                        <asp:CheckBox runat="server" ID="chkGrade1" class="ClassMTop" Text="1" />

                                    </div>
                                    <div class="col-md-2 ">
                                        <asp:CheckBox runat="server" ID="chkGrade2" class="ClassMTop" Text="2" />

                                    </div>
                                    <div class="col-md-2 ">
                                        <asp:CheckBox runat="server" ID="chkGrade3" class="ClassMTop" Text="3" />


                                    </div>
                                    <div class="col-md-2 ">
                                        <asp:CheckBox runat="server" ID="chkGrade4" class="ClassMTop" Text="4" />

                                    </div>

                                </div>
                                <div class="row">


                                    <div class="col-md-3 ClassMBold1">
                                        LMA :
                                  </div>
                                    <div class="col-md-5 ">
                                        <asp:TextBox runat="server" ID="txtLma" TextMode="MultiLine"></asp:TextBox>

                                    </div>
                                    <div class="col-md-3 ClassMBold">
                                    </div>
                                    <div class="col-md-5 ">
                                    </div>
                                    <div class="col-md-3 ClassMBold1">
                                        Size :
                                    </div>
                                    <div class="col-md-5 ">
                                        <asp:TextBox runat="server" ID="txtlmaSize" ></asp:TextBox>
                                    </div>

                                </div>
                                <div class="row">
                                    <div class="col-md-6 ClassSubHeading1">
                                        Regional
                                    </div>

                                </div>
                                <div class="row">
                                    <div class="col-md-6 ClassSubHeading1">
                                        Spinal
                                    </div>

                                </div>
                                <div class="row">
                                    <div class="col-md-3 ClassMBold">
                                        Position :
                                    </div>
                                    <div class="col-md-9 ">
                                        <asp:TextBox ID="txtRPosition" runat="server"> </asp:TextBox>
                                    </div>
                                    <div class="col-md-3 ClassMBold">
                                        Interspace :
                                    </div>
                                    <div class="col-md-9 ">
                                        <asp:TextBox ID="txtRInterspace" runat="server"> </asp:TextBox>
                                    </div>


                                </div>

                                <div class="row">
                                    <div class="col-md-3 ClassMBold">
                                        Needle guage :
                                    </div>
                                    <div class="col-md-9 ">
                                        <asp:TextBox ID="txtRNeedleguage" runat="server"> </asp:TextBox>
                                    </div>
                                    <div class="col-md-3 ClassMBold">
                                        Type :


                                    </div>
                                    <div class="col-md-9 ">
                                        <asp:TextBox ID="txtRType" runat="server"> </asp:TextBox>
                                    </div>


                                </div>
                                <div class="row">
                                    <div class="col-md-4 ClassMBold">
                                        Level of Sensory block :
                                    </div>
                                    <div class="col-md-20 ">
                                        <asp:TextBox ID="txtRLevelofSensoryblock" runat="server" TextMode="MultiLine"> </asp:TextBox>
                                    </div>



                                </div>


                                <div class="row">
                                    <div class="col-md-6 ClassSubHeading1">
                                        Epidural
                                    </div>

                                </div>
                                <div class="row">
                                    <div class="col-md-3 ClassMBold">
                                        Position :
                                    </div>
                                    <div class="col-md-9 ">
                                        <asp:TextBox ID="txtEPosition" runat="server"> </asp:TextBox>
                                    </div>
                                    <div class="col-md-3 ClassMBold">
                                        Interspace :
                                    </div>
                                    <div class="col-md-9 ">
                                        <asp:TextBox ID="txtEInterspace" runat="server"> </asp:TextBox>
                                    </div>


                                </div>

                                <div class="row">
                                    <div class="col-md-3 ClassMBold">
                                        Needle guage :
                                    </div>
                                    <div class="col-md-9 ">
                                        <asp:TextBox ID="txtENeedleguage" runat="server"> </asp:TextBox>
                                    </div>
                                    <div class="col-md-3 ClassMBold">
                                        LOR :


                                    </div>
                                    <div class="col-md-9 ">
                                        <asp:TextBox ID="txtELOR" runat="server"> </asp:TextBox>
                                    </div>


                                </div>
                                <div class="row">
                                    <div class="col-md-5 ClassMBold">
                                        Length of catheter in Epid. Space :
                                    </div>
                                    <div class="col-md-19 ">
                                        <asp:TextBox ID="txtELengthofcatheter" runat="server" TextMode="MultiLine"> </asp:TextBox>
                                    </div>



                                </div>
                                <div class="row">
                                    <div class="col-md-5 ClassMBold">
                                        Level of Sensory block :
                                    </div>
                                    <div class="col-md-19 ">
                                        <asp:TextBox ID="txtELevelofsensoryBlock" runat="server" TextMode="MultiLine"> </asp:TextBox>
                                    </div>



                                </div>

                                <div class="row">
                                    <div class="col-md-3 ClassMBold1">
                                        Plexus Block  :
                                    </div>
                                    <div class="col-md-9 ">
                                        <asp:CheckBox ID="chkPlexusBlock" runat="server" />
                                    </div>
                                    <div class="col-md-3 ClassMBold1">
                                        Type :
                                    </div>
                                    <div class="col-md-9 ">
                                        <asp:TextBox ID="txtEType" runat="server"> </asp:TextBox>
                                    </div>


                                </div>

                                <div class="row">
                                    <div class="col-md-3 ClassMBold1">
                                        Nerve Block :

                                    </div>
                                    <div class="col-md-9 ">
                                        <asp:CheckBox ID="chkNerveBlock" runat="server" />
                                    </div>
                                    <div class="col-md-3 ClassMBold1">
                                        Nerves Blocked :

                                    </div>
                                    <div class="col-md-9 ">
                                        <asp:TextBox ID="txtNervesBlocked" runat="server"> </asp:TextBox>
                                    </div>


                                </div>

                                <div class="row">
                                    <div class="col-md-3 ClassMBold1">
                                        IVRA :
                                    </div>
                                    <div class="col-md-9 ">
                                        <asp:CheckBox ID="chkIVRA" runat="server" />
                                    </div>
                                    <div class="col-md-3 ClassMBold1">
                                    </div>
                                    <div class="col-md-9 ">
                                    </div>


                                </div>

                            </div>

                        </div>

                        <div class="POuter_Box_Inventory">
                            <div class="row">
                                <div class="col-md-3 ClassMBold">
                                    IV Line :
                                </div>
                                <div class="col-md-5 ">
                                    <asp:CheckBox runat="server" ID="chkEIvLine" class="ClassMTop" />
                                </div>
                                <div class="col-md-3 ClassMBold">
                                    Site :
                                </div>
                                <div class="col-md-5 ">
                                    <asp:TextBox runat="server" ID="txtSite"></asp:TextBox>
                                </div>
                                <div class="col-md-3 ClassMBold">
                                    CVP :
                                </div>
                                <div class="col-md-5 ">
                                    <asp:CheckBox runat="server" ID="chkCVP" class="ClassMTop" />

                                </div>

                            </div>

                            <div class="row">
                                <div class="col-md-3 ClassMBold">
                                    Eyes protected :
                                </div>
                                <div class="col-md-5 ">
                                    <asp:CheckBox runat="server" ID="chkEEyeProtected" class="ClassMTop" />
                                </div>
                                <div class="col-md-3 ClassMBold">
                                </div>
                                <div class="col-md-5 ">
                                </div>
                                <div class="col-md-3 ClassMBold">
                                </div>
                                <div class="col-md-5 ">
                                </div>

                            </div>


                            <div class="row">

                                <div class="col-md-3 ClassMBold">
                                    Art Line :

                                </div>
                                <div class="col-md-5 ">
                                    <asp:CheckBox runat="server" ID="chkEArtLine" class="ClassMTop" />
                                </div>
                                <div class="col-md-3 ClassMBold">
                                    Position :
                                </div>
                                <div class="col-md-13 ">
                                    <asp:TextBox runat="server" ID="txtPosition"></asp:TextBox>
                                </div>



                            </div>


                        </div>


                        <div class="POuter_Box_Inventory">
                            <div class="row">
                                <div class="col-md-6 ClassSubHeading1">
                                    Conditions on Leaving O.T
                                </div>

                            </div>
                            <div class="row">
                                <div class="col-md-16 ClassSubHeading">
                                    Color
                                </div>
                                <div class="col-md-8 ClassSubHeading">
                                    Breathing

                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-3 ClassMBold">
                                    Pale
                                </div>
                                <div class="col-md-5 ">
                                    <asp:CheckBox runat="server" ID="chkCPale" class="ClassMTop" />
                                </div>
                                <div class="col-md-2 ClassMBold">
                                </div>
                                <div class="col-md-6 ">
                                </div>
                                <div class="col-md-3 ClassMBold">
                                    SR/Good

                                </div>
                                <div class="col-md-5 ">
                                    <asp:CheckBox runat="server" ID="chkBSRGood" class="ClassMTop" />
                                </div>

                            </div>
                            <div class="row">
                                <div class="col-md-3 ClassMBold">
                                    Pink

                                </div>
                                <div class="col-md-5 ">
                                    <asp:CheckBox runat="server" ID="chkCPink" class="ClassMTop" />
                                </div>
                                <div class="col-md-2 ClassMBold">
                                </div>
                                <div class="col-md-6 ">
                                </div>
                                <div class="col-md-3 ClassMBold">
                                    SR/Shallow


                                </div>
                                <div class="col-md-5 ">
                                    <asp:CheckBox runat="server" ID="chkBSRShallow" class="ClassMTop" />
                                </div>

                            </div>
                            <div class="row">
                                <div class="col-md-3 ClassMBold">
                                    Cyanotic
                 
                                </div>
                                <div class="col-md-5 ">
                                    <asp:CheckBox runat="server" ID="chkCCyanotic" class="ClassMTop" />
                                </div>
                                <div class="col-md-2 ClassMBold">
                                </div>
                                <div class="col-md-6 ">
                                </div>
                                <div class="col-md-3 ClassMBold">
                                    Asst/IPPV
                                </div>
                                <div class="col-md-5 ">
                                    <asp:CheckBox runat="server" ID="chkBAsstIPPV" class="ClassMTop" />
                                </div>

                            </div>
                            <div class="row">
                                <div class="col-md-3 ClassMBold">
                                    BP

                                </div>
                                <div class="col-md-5 ">
                                    <asp:TextBox ID="txtBP" runat="server"></asp:TextBox>
                                </div>
                                <div class="col-md-2 ClassMBold">
                                </div>
                                <div class="col-md-6 ">
                                </div>
                                <div class="col-md-3 ClassMBold">
                                </div>
                                <div class="col-md-5 ">
                                </div>

                            </div>
                            <div class="row">
                                <div class="col-md-3 ClassMBold">
                                    Pulse
                 
                                </div>
                                <div class="col-md-5 ">
                                    <asp:TextBox ID="txtPulse" runat="server"></asp:TextBox>
                                </div>
                                <div class="col-md-2 ClassMBold">
                                </div>
                                <div class="col-md-6 ">
                                </div>
                                <div class="col-md-3 ClassMBold">
                                </div>
                                <div class="col-md-5 ">
                                </div>

                            </div>

                            <div class="row">
                                <div class="col-md-16 ClassSubHeading">
                                    State of Consciousness
                                </div>

                            </div>
                            <div class="row">
                                <div class="col-md-3 ClassMBold">
                                    Awake

                                </div>
                                <div class="col-md-5 ">
                                    <asp:CheckBox runat="server" ID="chkAwake" class="ClassMTop" />
                                </div>
                                <div class="col-md-2 ClassMBold">
                                </div>
                                <div class="col-md-6 ">
                                </div>
                                <div class="col-md-3 ClassMBold">
                                    Unconscious
                                </div>
                                <div class="col-md-5 ">
                                    <asp:CheckBox runat="server" ID="chkUnconscious" class="ClassMTop" />
                                </div>

                            </div>
                            <div class="row">
                                <div class="col-md-3 ClassMBold">
                                    Drowsy
                 
                                </div>
                                <div class="col-md-5 ">
                                    <asp:CheckBox runat="server" ID="chkDrowsy" class="ClassMTop" />
                                </div>
                                <div class="col-md-2 ClassMBold">
                                </div>
                                <div class="col-md-6 ">
                                </div>
                                <div class="col-md-3 ClassMBold">
                                </div>
                                <div class="col-md-5 ">
                                </div>

                            </div>
                            <div class="row">
                                <div class="col-md-4 ClassMBold">
                                    Anaesthesia Commenced
                 
                                </div>
                                <div class="col-md-20 ">
                                    <asp:TextBox ID="txtAnaesthesiaCommenced" runat="server" TextMode="MultiLine"></asp:TextBox>
                                </div>


                            </div>
                            <div class="row">
                                <div class="col-md-4 ClassMBold">
                                    Anaesthesia Ended.
                                </div>
                                <div class="col-md-20 ">
                                    <asp:TextBox ID="txtAnaesthesiaEnded" runat="server" TextMode="MultiLine"></asp:TextBox>
                                </div>


                            </div>
                            <div class="row">
                                <div class="col-md-4 ClassMBold">
                                    E. Blood loss :
                                </div>
                                <div class="col-md-20 ">
                                    <asp:TextBox ID="txtBloodLoss" runat="server" TextMode="MultiLine"></asp:TextBox>
                                </div>


                            </div>
                            <div class="row">
                                <div class="col-md-4 ClassMBold">
                                    Urine output :
                                </div>
                                <div class="col-md-20 ">
                                    <asp:TextBox ID="txtUrineoutput" runat="server" TextMode="MultiLine"></asp:TextBox>
                                </div>


                            </div>

                            <div class="row">
                                <div class="col-md-3 ClassMBold">
                                    Extubation

                                </div>
                                <div class="col-md-5 ">
                                    <asp:CheckBox runat="server" ID="chkExtubation" class="ClassMTop" />
                                </div>
                                <div class="col-md-2 ClassMBold">
                                </div>
                                <div class="col-md-6 ">
                                </div>
                                <div class="col-md-3 ClassMBold">
                                </div>
                                <div class="col-md-5 ">
                                </div>

                            </div>

                        </div>




                    </div>

                </div>


            </div>

            <div class="POuter_Box_Inventory" style="text-align: center;">

                <asp:Button ID="btnSave" runat="server" Text="Save" class="ItDoseButton" OnClick="btnSave_Click" />
                <asp:Label ID="lblID" Text="" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
            </div>
        </div>

    </form>
</body>
</html>

