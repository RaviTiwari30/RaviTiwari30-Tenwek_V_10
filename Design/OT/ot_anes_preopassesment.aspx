<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ot_anes_preopassesment.aspx.cs" Inherits="Design_OT_ot_anes_preopassesment" %>

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
            margin-left: -20px;
        }

        .ClassMBold {
            font-weight: bold;
        }

        .ClassHeading {
            font-size: 20px;
        }

        .ClassSubHeading {
            font-size: 16px;
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
                    <b>Pro-Op Assesment</b>
                </div>
                <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-14 ">

                        <div class="POuter_Box_Inventory">
                            <div class="row">

                                <b class="ClassHeading">History
                                </b>


                            </div>
                            <div class="row ClassNormalform">

                                <div class="col-md-8">
                                    Previous Anaesthetics &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" TextMode="MultiLine" ID="txtPreviousAnaesthetics"></asp:TextBox>
                                </div>


                            </div>


                            <div class="row ClassNormalform">

                                <div class="col-md-8">
                                    Co-morbidity &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" TextMode="MultiLine" ID="txtCoMorbidity"></asp:TextBox>
                                </div>


                            </div>

                            <div class="row ClassNormalform">

                                <div class="col-md-8">
                                    Drug Hx&nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" TextMode="MultiLine" ID="txtDrugHx"></asp:TextBox>
                                </div>


                            </div>
                            <div class="row">
                                <div class="col-md-24">
                                    <b class="ClassSubHeading">Allergies
                                    </b>
                                </div>
                            </div>

                            <div class="row ClassNormalform">

                                <div class="col-md-3 ClassMBold">
                                    Alcohol &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-4">
                                    <asp:RadioButtonList ID="rblAlcohol" runat="server" CssClass="ClassMTop" RepeatDirection="Horizontal">
                                        <asp:ListItem Text="Yes" Value="1" />
                                        <asp:ListItem Text="No" Value="0" Selected="True" />
                                    </asp:RadioButtonList>

                                </div>

                                <div class="col-md-3 ClassMBold">
                                    Smoking  <b>:</b>
                                </div>

                                <div class="col-md-4">
                                    <asp:RadioButtonList ID="rblSmoking" runat="server" CssClass="ClassMTop" RepeatDirection="Horizontal">
                                        <asp:ListItem Text="Yes" Value="1" />
                                        <asp:ListItem Text="No" Value="0" Selected="True" />
                                    </asp:RadioButtonList>

                                </div>
                            </div>


                            <div class="row">

                                <b class="ClassHeading">Examination
                                </b>

                            </div>
                            <div class="row">
                                <div class="col-md-24">
                                    <b class="ClassSubHeading">General :
                                    </b>
                                </div>
                            </div>

                            <div class="row ClassNormalform">

                                <div class="col-md-3 ClassMBold">
                                    Palor &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-4">
                                    <asp:RadioButtonList ID="rblPalor" runat="server" CssClass="ClassMTop" RepeatDirection="Horizontal">
                                        <asp:ListItem Text="Yes" Value="1" />
                                        <asp:ListItem Text="No" Value="0" Selected="True" />
                                    </asp:RadioButtonList>

                                </div>

                                <div class="col-md-3 ClassMBold">
                                    Jaundice<b>:</b>
                                </div>

                                <div class="col-md-4">
                                    <asp:RadioButtonList ID="rblJaundice" runat="server" CssClass="ClassMTop" RepeatDirection="Horizontal">
                                        <asp:ListItem Text="Yes" Value="1" />
                                        <asp:ListItem Text="No" Value="0" Selected="True" />
                                    </asp:RadioButtonList>

                                </div>
                                <div class="col-md-3">
                                    Temp <b>:</b>
                                </div>
                                <div class="col-md-7">
                                    <asp:TextBox ID="txtTemp" runat="server" TextMode="Number"></asp:TextBox>
                                </div>
                            </div>




                            <div class="row ClassNormalform">


                                <div class="col-md-8">
                                    Oedema &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" TextMode="MultiLine" ID="txtOedema"></asp:TextBox>
                                </div>


                            </div>

                            <div class="row ClassNormalform">

                                <div class="col-md-8">
                                    Hydration
&nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" TextMode="MultiLine" ID="txtHydration"></asp:TextBox>
                                </div>


                            </div>


                            <div class="row ClassNormalform">


                                <div class="col-md-8">
                                    Others &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" TextMode="MultiLine" ID="txtGenOthers"></asp:TextBox>
                                </div>


                            </div>

                            <div class="row">
                                <div class="col-md-24">
                                    <b class="ClassSubHeading">CVS :
                                    </b>
                                </div>
                            </div>



                            <div class="row ClassNormalform">


                                <div class="col-md-8">
                                    Pulse &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtPulse"></asp:TextBox>
                                </div>


                            </div>



                            <div class="row ClassNormalform">


                                <div class="col-md-8">
                                    BP &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtBP"></asp:TextBox>
                                </div>


                            </div>




                            <div class="row ClassNormalform">


                                <div class="col-md-8">
                                    HS &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtHS"></asp:TextBox>
                                </div>


                            </div>

                            <div class="row">
                                <div class="col-md-24">
                                    <b class="ClassSubHeading">Respiratory :
                                    </b>
                                </div>
                            </div>

                            <div class="row ClassNormalform">


                                <div class="col-md-8">
                                    RR &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtRR"></asp:TextBox>
                                </div>


                            </div>
                            <div class="row ClassNormalform">


                                <div class="col-md-8">
                                    SPO<sub>2</sub> on Room Air  &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtSpo2"></asp:TextBox>
                                </div>


                            </div>
                            <div class="row ClassNormalform">


                                <div class="col-md-8">
                                    Auscultation &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtAuscultation" TextMode="MultiLine"></asp:TextBox>
                                </div>


                            </div>

                            <div class="row ClassNormalform">


                                <div class="col-md-8">
                                    CNS &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtCns"></asp:TextBox>
                                </div>


                            </div>


                            <div class="row ClassNormalform">


                                <div class="col-md-8">
                                    Abdomen &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtAbdomen"></asp:TextBox>
                                </div>


                            </div>
                            <div class="row ClassNormalform">


                                <div class="col-md-8">
                                    Others Systems &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtOtherssystems" TextMode="MultiLine"></asp:TextBox>
                                </div>


                            </div>

                            <div class="row ClassNormalform">


                                <div class="col-md-8">
                                    Neck Mobility &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtNeckMobility"></asp:TextBox>
                                </div>


                            </div>
                            <div class="row ClassNormalform">


                                <div class="col-md-8">
                                    Mouth Opening &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtMouthOpening"></asp:TextBox>
                                </div>


                            </div>
                            <div class="row ClassNormalform">


                                <div class="col-md-8">
                                    Thyromental Distance &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtThyromentaldistance"></asp:TextBox>
                                </div>


                            </div>
                            <div class="row ClassNormalform">


                                <div class="col-md-8">
                                    Mallampati &nbsp; <b>:</b>
                                </div>
                                <div class="col-md-2">
                                    <asp:CheckBox ID="chkMallampati1" runat="server" ClientIDMode="Static" Text="1" />
                                </div>
                                <div class="col-md-2">
                                    <asp:CheckBox ID="chkMallampati2" runat="server" ClientIDMode="Static" Text="2" />
                                </div>
                                <div class="col-md-2">
                                    <asp:CheckBox ID="chkMallampati3" runat="server" ClientIDMode="Static" Text="3" />
                                </div>
                                <div class="col-md-2">
                                    <asp:CheckBox ID="chkMallampati4" runat="server" ClientIDMode="Static" Text="4" />
                                </div>
                            </div>

                            <div class="row ClassNormalform">


                                <div class="col-md-8">
                                    ASA Status &nbsp; <b>:</b>
                                </div>
                                <div class="col-md-2">
                                    <asp:CheckBox ID="chkASA1" runat="server" ClientIDMode="Static" Text="1" />
                                </div>
                                <div class="col-md-2">
                                    <asp:CheckBox ID="chkASA2" runat="server" ClientIDMode="Static" Text="2" />
                                </div>
                                <div class="col-md-2">
                                    <asp:CheckBox ID="chkASA3" runat="server" ClientIDMode="Static" Text="3" />
                                </div>
                                <div class="col-md-2">
                                    <asp:CheckBox ID="chkASA4" runat="server" ClientIDMode="Static" Text="4" />
                                </div>
                                <div class="col-md-2">
                                    <asp:CheckBox ID="chkASA5" runat="server" ClientIDMode="Static" Text="5" />
                                </div>
                                <div class="col-md-2">
                                    <asp:CheckBox ID="chkASA6" runat="server" ClientIDMode="Static" Text="E" />
                                </div>

                            </div>
                            <div class="row ClassNormalform">

                                <div class="col-md-8">Date <b>:</b></div>

                                <div class="col-md-5">
                                    <asp:TextBox ID="txtDate" runat="server" ClientIDMode="Static"></asp:TextBox>
                                    <cc1:CalendarExtender ID="calDate" PopupButtonID="imgPopup" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                                </div>

                                <div class="col-md-3">Time <b>:</b></div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtTime" runat="server" Width="100px"></asp:TextBox>
                                    <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTime"
                                        Mask="99:99" MaskType="Time" AcceptAMPM="true" />

                                    <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtTime"
                                        ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                        InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                                    <br />
                                    <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                                </div>
                            </div>


                        </div>

                    </div>
                    <div class="col-md-10">
                        <div class="POuter_Box_Inventory">
                            <div class="row">

                                <b class="ClassHeading">Pro-Op Investigations
                                </b>


                            </div>

                            <div class="row">
                                <div class="col-md-24">
                                    <b class="ClassSubHeading">Haematology  :
                                    </b>
                                </div>
                            </div>
                            <div class="row ClassNormalform">
                                <div class="col-md-8">
                                    Hb
 &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtHB"></asp:TextBox>
                                </div>
                            </div>

                            <div class="row ClassNormalform">
                                <div class="col-md-8">
                                    Sickling &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtSickling"></asp:TextBox>
                                </div>
                            </div>

                            <div class="row ClassNormalform">
                                <div class="col-md-8">
                                    Platelets
 &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtPlatelets"></asp:TextBox>
                                </div>
                            </div>

                            <div class="row ClassNormalform">
                                <div class="col-md-8">
                                    WBC
 &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtWBC"></asp:TextBox>
                                </div>
                            </div>

                            <div class="row ClassNormalform">
                                <div class="col-md-8">
                                    ESR&nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtESR"></asp:TextBox>
                                </div>
                            </div>

                            <div class="row ClassNormalform">
                                <div class="col-md-8">
                                    APTT &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtAPTT"></asp:TextBox>
                                </div>
                            </div>

                            <div class="row ClassNormalform">
                                <div class="col-md-8">
                                    INR &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtINR"></asp:TextBox>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-24">
                                    <b class="ClassSubHeading">Biochemistry  :
                                    </b>
                                </div>
                            </div>
                            <div class="row ClassNormalform">
                                <div class="col-md-8">
                                    Na
 &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtNa"></asp:TextBox>
                                </div>
                            </div>

                            <div class="row ClassNormalform">
                                <div class="col-md-8">
                                    K+
 &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtK"></asp:TextBox>
                                </div>
                            </div>

                            <div class="row ClassNormalform">
                                <div class="col-md-8">
                                    Ca+
 &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtCa"></asp:TextBox>
                                </div>
                            </div>

                            <div class="row ClassNormalform">
                                <div class="col-md-8">
                                    Urea &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtUrea"></asp:TextBox>
                                </div>
                            </div>

                            <div class="row ClassNormalform">
                                <div class="col-md-8">
                                    Creatinine &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtCreatinine"></asp:TextBox>
                                </div>
                            </div>

                            <div class="row ClassNormalform">
                                <div class="col-md-8">
                                    LFT &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtLFT"></asp:TextBox>
                                </div>
                            </div>

                            <div class="row ClassNormalform">
                                <div class="col-md-8">
                                    FBS &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtFBS"></asp:TextBox>
                                </div>
                            </div>

                            <div class="row ClassNormalform">
                                <div class="col-md-8">
                                    Hormonal Assays &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtHormonalAssays" TextMode="MultiLine" Height="105px"></asp:TextBox>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-24">
                                    <b class="ClassSubHeading">Microbiology  :
                                    </b>
                                </div>
                            </div>

                            <div class="row ClassNormalform">
                                <div class="col-md-8">
                                    Hepatitis&nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtHepatitis"></asp:TextBox>
                                </div>
                            </div>

                            <div class="row ClassNormalform">
                                <div class="col-md-8">
                                    HIV &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtHIV"></asp:TextBox>
                                </div>
                            </div>

                            <div class="row ClassNormalform">
                                <div class="col-md-8">
                                    Urine C/S &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtUrine"></asp:TextBox>
                                </div>
                            </div>



                            <div class="row ClassNormalform">
                                <div class="col-md-8">
                                    MPS &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtMPS"></asp:TextBox>
                                </div>
                            </div>
                            <div class="row ClassNormalform">
                                <div class="col-md-8">
                                    ECG &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtECG" TextMode="MultiLine"></asp:TextBox>
                                </div>
                            </div>
                            <div class="row ClassNormalform">
                                <div class="col-md-8">
                                    CXR &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtCXR" TextMode="MultiLine"></asp:TextBox>
                                </div>
                            </div>

                            <div class="row ClassNormalform">
                                <div class="col-md-8">
                                    Urinalysis &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtUrinalysis" TextMode="MultiLine"></asp:TextBox>
                                </div>
                            </div>

                            <div class="row ClassNormalform">
                                <div class="col-md-8">
                                    Others &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-16">
                                    <asp:TextBox runat="server" ID="txtOthers" TextMode="MultiLine"></asp:TextBox>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="POuter_Box_Inventory">

                            <div class="row ClassNormalform">

                                <div class="col-md-2">
                                   Notes &nbsp; <b>:</b>
                                </div>

                                <div class="col-md-22">
                                    <asp:TextBox runat="server" TextMode="MultiLine" ID="txtNotes"></asp:TextBox>
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

