<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ot_anes_record.aspx.cs" Inherits="Design_OT_ot_anes_record" %>

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
                    <b>ANAESTHETIC RECORD</b>
                </div>
                <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-24" style="display: block;">
                        <div class="row">
                            <div class="col-md-3">Name  &nbsp; <b>:</b></div>
                            <div class="col-md-13"><asp:Label runat="server" ID="lblName"></asp:Label></div>
                            <div class="col-md-3">
                                <label>Pre Op. Diagnosis   &nbsp; <b>:</b></label>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox runat="server" TextMode="MultiLine" ID="txtPreOpDiagnosis"></asp:TextBox>
                            </div>
                        </div>
                        <div class="row">

                            <div class="col-md-3">
                                Age  &nbsp; <b>:</b>
                            </div>
                          
                            <div class="col-md-5">
                               <asp:Label runat="server" ID="lblAge"></asp:Label>
                            </div>

                            <div class="col-md-3">
                                Allergies   &nbsp; <b>:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox runat="server" TextMode="MultiLine" ID="txtAllergies"></asp:TextBox>
                            </div>

                            <div class="col-md-3">
                                Proposed Operation   &nbsp; <b>:</b>
                            </div>

                            <div class="col-md-5">
                                  <asp:TextBox runat="server" TextMode="MultiLine" ID="txtPropOp"></asp:TextBox>
                            </div>


                        </div>

                        <div class="row">

                            <div class="col-md-3">
                                Sex   &nbsp; <b>:</b>
                            </div>
                            <div class="col-md-5">
                                   <asp:Label runat="server" ID="lblSex"></asp:Label>
                            </div>

                            <div class="col-md-3">
                                Weight(Kg)  &nbsp; <b>:</b>
                            </div>
                            <div class="col-md-5">
                                   <asp:TextBox runat="server" TextMode="Number" ID="txtWeight"></asp:TextBox>
                            </div>

                            <div class="col-md-3">
                                Intro. Op Diagnosis   &nbsp; <b>:</b>
                            </div>
                            <div class="col-md-5">
                                 <asp:TextBox runat="server" TextMode="MultiLine" ID="txtIntroOpDiag"></asp:TextBox>
                            </div>


                        </div>

                        <div class="row">

                            <div class="col-md-3">
                                Height (cm)   &nbsp; <b>:</b>
                            </div>
                            <div class="col-md-5">
                                 <asp:TextBox runat="server" TextMode="Number" ID="txtHeight"></asp:TextBox>
                            </div>

                            <div class="col-md-3">
                                BMI   &nbsp; <b>:</b>
                            </div>
                            <div class="col-md-5">
                                 <asp:TextBox runat="server"  ID="txtBMI"></asp:TextBox>
                            </div>

                            <div class="col-md-3">
                              Operation   &nbsp; <b>:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox runat="server" TextMode="MultiLine" ID="txtOperation"></asp:TextBox>
                            </div>


                        </div>



                        <div class="row">

                            <div class="col-md-3">
                              Date   &nbsp; <b>:</b>
                            </div>
                            <div class="col-md-5">
                                 <asp:TextBox ID="txtDate" runat="server" ClientIDMode="Static"></asp:TextBox>  
                    <cc1:CalendarExtender ID="calDate" PopupButtonID="imgPopup" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy"> </cc1:CalendarExtender>  
               
                            </div>

                            <div class="col-md-3">
                                ID   &nbsp; <b>:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label runat="server" ID="lblIDs"></asp:Label>
                            </div>

                            <div class="col-md-3">
                                OP. Typ (EL/EM/UR)   &nbsp; <b>:</b>
                            </div>
                            <div class="col-md-5">
                                  <asp:TextBox runat="server" TextMode="MultiLine" ID="txtOpType"></asp:TextBox>
                            </div>


                        </div>

                        
                        <div class="row">

                            <div class="col-md-3">
                             
                            </div>
                            <div class="col-md-5">
                            </div>

                            <div class="col-md-3">
                                Blood Group    &nbsp; <b>:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox runat="server" ID="txtBG"></asp:TextBox>
                            </div>

                            <div class="col-md-3">
                               Units Available   &nbsp; <b>:</b>
                            </div>
                            <div class="col-md-5">
                                  <asp:TextBox runat="server" ID="txtUnitAvailable"></asp:TextBox>
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
