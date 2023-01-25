<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BloodTransfusion.aspx.cs" Inherits="Design_BloodBank_BloodTransfusion" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {


            if ($('#txtTemBefor').val() != "" && $('#txtPulseBefore').val() != "" && $('#txtBloodBefore').val() != "") {
                $('#tbl1').show();
            }

            if ($('#txtTemBefor').val() == "") {
                $('#txtTemDuring').attr("disabled", "disabled");
                $('#txtTemAfter').attr("disabled", "disabled");


            }

            if ($('#txtTemDuring').val() == "" && $('#txtTemBefor').val() != "") {
                $('#txtTemBefor').attr('readonly', 'readonly');
                $('#txtTemAfter').attr("disabled", "disabled");

            }
            if ($('#txtTemDuring').val() != "" && $('#txtTemBefor').val() != "") {
                $('#txtTemBefor').attr('readonly', 'readonly');
                $('#txtTemDuring').attr('readonly', 'readonly');
                $('#txtTemAfter').attr("disabled", false);

            }
            if ($('#txtTemDuring').val() != "" && $('#txtTemBefor').val() != "" && $('#txtTemAfter').val() != "") {
                $('#txtTemBefor').attr('readonly', 'readonly');
                $('#txtTemDuring').attr('readonly', 'readonly');
                $('#txtTemAfter').attr('readonly', 'readonly');

            }


            if ($('#txtPulseBefore').val() == "") {
                $('#txtPulseDuring').attr("disabled", "disabled");
                $('#txtPulseAfter').attr("disabled", "disabled");

            }
            if ($('#txtPulseDuring').val() == "" && $('#txtPulseBefore').val() != "") {
                $('#txtPulseBefore').attr('readonly', 'readonly');
                $('#txtPulseAfter').attr("disabled", "disabled");
            }
            if ($('#txtPulseDuring').val() != "" && $('#txtPulseBefore').val() != "") {
                $('#txtPulseBefore').attr('readonly', 'readonly');
                $('#txtPulseDuring').attr('readonly', 'readonly');
                $('#txtPulseAfter').attr("disabled", false);
            }
            if ($('#txtPulseDuring').val() != "" && $('#txtPulseBefore').val() != "" && $('#txtPulseAfter').val() != "") {
                $('#txtPulseBefore').attr('readonly', 'readonly');
                $('#txtPulseDuring').attr('readonly', 'readonly');
                $('#txtPulseAfter').attr('readonly', 'readonly');
            }


            if ($('#txtBloodBefore').val() == "") {
                $('#txtBloodDuring').attr("disabled", "disabled");
                $('#txtBloodAfter').attr("disabled", "disabled");


            }

            if ($('#txtBloodDuring').val() == "" && $('#txtBloodBefore').val() != "") {
                $('#txtBloodBefore').attr('readonly', 'readonly');
                $('#txtBloodAfter').attr("disabled", "disabled");

            }
            if ($('#txtBloodDuring').val() != "" && $('#txtBloodBefore').val() != "") {
                $('#txtBloodBefore').attr('readonly', 'readonly');
                $('#txtBloodDuring').attr('readonly', 'readonly');
                $('#txtBloodAfter').attr("disabled", false);

            }
            if ($('#txtBloodDuring').val() != "" && $('#txtBloodBefore').val() != "" && $('#txtBloodAfter').val() != "") {
                $('#txtBloodBefore').attr('readonly', 'readonly');
                $('#txtBloodDuring').attr('readonly', 'readonly');
                $('#txtBloodAfter').attr('readonly', 'readonly');

            }
        });


        function checkForSecondDecimal(sender, e) {
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));
                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;
        }
        function checkForSecond(sender, e) {
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;


            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));


                if ((charCode == 47)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '/');
                        if (hasDec)
                            return false;
                    }
                }
            }
            return true;
        }
    </script>
</head>


<!DOCTYPE html>

<%--<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
     
    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet"  type="text/css"/>
    <script type="text/javascript" src="../../../Scripts/jquery-1.7.1.min.js"></script>

  

    <style type="text/css">
        .auto-style1 {
            height: 30px;
        }
    </style>

  

</head>--%><body>
    <%-- <script type="text/javascript">
         $(document).ready(function(){
             if ($('#txtTemBefor.ClientID %>').val().length != 0) {
                
                 $('#txtTemBefor.ClientID %>').attr('disabled', true);
                 $('#<%=txtTemDuring.ClientID %>').removeAttr("disabled");
                 $('#txtTemAfter.ClientID %>').attr('disabled', true);
             }
             else
             {
                 $('#txtTemDuring.ClientID %>').attr('disabled', true);
                 $('#txtTemAfter.ClientID %>').attr('disabled', true);
                
             }
         });
         </script>--%>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <Ajax:ScriptManager ID="sm" runat="server" />
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>Blood Transfusion  Monitoring Form </b>
                <br />
                <asp:Label ID="lblMg" runat="server" Font-Bold="true" CssClass="ItDoseLblError"></asp:Label>


            </div>
            <div class="POuter_Box_Inventory">
                 <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Batch No.
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList ID="ddlBatchNo" runat="server" AutoPostBack="true" EnableViewState="true" OnSelectedIndexChanged="ddlBatchNo_SelectedIndexChanged"></asp:DropDownList>

                    </div>
                    <div style="display: none" class="col-md-3">
                        <label class="pull-left">
                            Component Name
                        </label>
                        <b class="pull-right">:</b>
                    </div>

                    <div style="display: none" class="col-md-5">
                        <asp:Label runat="server" ID="lblComponantName" Text="dfdgfgfg"></asp:Label>
                    </div>
                </div>



                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Quantity Given
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:Label ID="lblQuantity" CssClass="patientInfo" runat="server"></asp:Label>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                            Blood Bag No.
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:Label ID="lblBBankNo" CssClass="patientInfo" runat="server"></asp:Label>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                            Group and Rh 
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:Label ID="lblGroup" CssClass="patientInfo" runat="server"></asp:Label>
                    </div>
                </div>
               


            </div>

            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-6"></div>
                            <div class="col-md-6">Before  Transfusion</div>
                            <div class="col-md-6">During Transfusion</div>
                            <div class="col-md-6">After Transfusion</div>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left">
                                    Temperature 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-6">
                                <asp:TextBox ID="txtTemBefor" runat="server" ClientIDMode="Static" Width="55px" onkeypress="return checkForSecondDecimal(this,event)" TabIndex="18" MaxLength="5" ToolTip="Enter T"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <asp:TextBox ID="txtTemDuring" runat="server" ClientIDMode="Static" Width="55px" onkeypress="return checkForSecondDecimal(this,event)" TabIndex="18" MaxLength="5" ToolTip="Enter T"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <asp:TextBox ID="txtTemAfter" runat="server" ClientIDMode="Static" Width="55px" onkeypress="return checkForSecondDecimal(this,event)" TabIndex="18" MaxLength="5" ToolTip="Enter T"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>

                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left">
                                    Pulse rate
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-6">
                                <asp:TextBox ID="txtPulseBefore" runat="server" ClientIDMode="Static" Width="55px" onkeypress="return checkForSecondDecimal(this,event)" TabIndex="16" MaxLength="5" ToolTip="Enter p"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <asp:TextBox ID="txtPulseDuring" runat="server" ClientIDMode="Static" Width="55px" onkeypress="return checkForSecondDecimal(this,event)" TabIndex="16" MaxLength="5" ToolTip="Enter p"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <asp:TextBox ID="txtPulseAfter" runat="server" ClientIDMode="Static" Width="55px" onkeypress="return checkForSecondDecimal(this,event)" TabIndex="16" MaxLength="5" ToolTip="Enter p"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>

                <div class="row">
                    <div class="col-md-1"></div>
                    <div class="col-md-22">
                        <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left">
                                    Blood pressure	
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-6">
                                <asp:TextBox ID="txtBloodBefore" runat="server" ClientIDMode="Static" Width="55px" onkeypress="return checkForSecond(this,event)" TabIndex="15" MaxLength="7" ToolTip="Enter BP"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <asp:TextBox ID="txtBloodDuring" runat="server" ClientIDMode="Static" Width="55px" onkeypress="return checkForSecond(this,event)" TabIndex="15" MaxLength="7" ToolTip="Enter BP"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <asp:TextBox ID="txtBloodAfter" runat="server" ClientIDMode="Static" Width="55px" onkeypress="return checkForSecond(this,event)" TabIndex="15" MaxLength="7" ToolTip="Enter BP"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
            </div>
            <div class="Outer_Box_Inventory" style="width: 100%; border-collapse: collapse; display: none">
                <table>
                    <tr>
                        <td></td>
                    </tr>
                    <tr>
                        <td></td>
                    </tr>
                    <tr>
                        <td colspan="4">

                            <table id="tbl1" class="Outer_Box_Inventory" style="width: 100%;">

                                <tr>
                                    <td>4. Other Signs and Symptoms </td>
                                </tr>
                                <tr>
                                    <td>a. Chills </td>
                                    <td>
                                        <asp:RadioButtonList ID="rbtChills" runat="server" RepeatDirection="Horizontal" class="rad" Height="26px" Width="136px">
                                            <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="No" Value="0" Selected="True"></asp:ListItem>
                                        </asp:RadioButtonList></td>
                                    <td colspan="2" style="width: 151px"></td>
                                    <td>e. Haemoglobinnurea </td>
                                    <td>
                                        <asp:RadioButtonList ID="rbtHaemo" runat="server" RepeatDirection="Horizontal" class="rad" Height="26px" Width="136px">
                                            <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="No" Value="0" Selected="True"></asp:ListItem>
                                        </asp:RadioButtonList></td>
                                </tr>
                                <tr>
                                    <td>b. Rigor </td>
                                    <td>
                                        <asp:RadioButtonList ID="rbtRigor" runat="server" RepeatDirection="Horizontal" class="rad" Height="26px" Width="136px">
                                            <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="No" Value="0" Selected="True"></asp:ListItem>
                                        </asp:RadioButtonList></td>
                                    <td colspan="2" style="width: 151px"></td>
                                    <td>f. Pulmonary oedema </td>
                                    <td style="width: 104px">
                                        <asp:RadioButtonList ID="rbtPolmonary" runat="server" RepeatDirection="Horizontal" class="rad" Height="26px" Width="136px">
                                            <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="No" Value="0" Selected="True"></asp:ListItem>
                                        </asp:RadioButtonList></td>
                                </tr>
                                <tr>
                                    <td>c. Rash/Itching </td>
                                    <td>
                                        <asp:RadioButtonList ID="rbtRash" runat="server" RepeatDirection="Horizontal" class="rad" Height="26px" Width="136px">
                                            <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="No" Value="0" Selected="True"></asp:ListItem>
                                        </asp:RadioButtonList></td>
                                    <td colspan="2" style="width: 151px"></td>
                                    <td>g. Juandice </td>
                                    <td style="width: 104px">
                                        <asp:RadioButtonList ID="rbtJaundice" runat="server" RepeatDirection="Horizontal" class="rad" Height="26px" Width="136px">
                                            <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="No" Value="0" Selected="True"></asp:ListItem>
                                        </asp:RadioButtonList></td>
                                </tr>

                                <tr>
                                    <td>d. Pain-back </td>
                                    <td>
                                        <asp:RadioButtonList ID="rbtPain" runat="server" RepeatDirection="Horizontal" class="rad" Height="26px" Width="136px">
                                            <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="No" Value="0" Selected="True"></asp:ListItem>
                                        </asp:RadioButtonList></td>
                                    <td colspan="2" style="width: 151px"></td>
                                    <td>h. Any Other Signs </td>
                                    <td style="width: 104px">
                                        <asp:RadioButtonList ID="rbtOther" runat="server" RepeatDirection="Horizontal" class="rad" Height="26px" Width="136px">
                                            <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="No" Value="0" Selected="True"></asp:ListItem>
                                        </asp:RadioButtonList></td>
                                </tr>
                                <tr>
                                    <td>&nbsp;&nbsp;&nbsp;&nbsp; Head </td>
                                    <td>
                                        <asp:RadioButtonList ID="rbtHead" runat="server" RepeatDirection="Horizontal" class="rad" Height="26px" Width="136px">
                                            <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="No" Value="0" Selected="True"></asp:ListItem>
                                        </asp:RadioButtonList></td>

                                </tr>
                                <tr>
                                    <td>&nbsp;&nbsp;&nbsp;&nbsp; Chest </td>
                                    <td>
                                        <asp:RadioButtonList ID="rbtChest" runat="server" RepeatDirection="Horizontal" class="rad" Height="26px" Width="136px">
                                            <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="No" Value="0" Selected="True"></asp:ListItem>
                                        </asp:RadioButtonList></td>

                                </tr>
                                <tr>
                                    <td>&nbsp;&nbsp;&nbsp;&nbsp; ElseWhere </td>
                                    <td>
                                        <asp:RadioButtonList ID="rbtElse" runat="server" RepeatDirection="Horizontal" class="rad" Height="26px" Width="136px">
                                            <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="No" Value="0" Selected="True"></asp:ListItem>
                                        </asp:RadioButtonList></td>

                                </tr>
                            </table>



                        </td>
                    </tr>
                    <tr>
                        <td colspan="4"></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                        </td>
                    </tr>



                </table>

            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-3">
                          <label class="pull-left">
                            Note
                        </label>
                        <b class="pull-right">:-</b>
                    </div>
                    <div class="col-md-21">
                           In the event of a severe reaction occurring stop transfusion the blood blank should be informed immediately and the remains of the unit used with transfusion set in ? returned to the blood blank, together with the post transfusion samples of the patient's blood collected into
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                    </div>
                    <div class="col-md-21">
                        a. Dry steril vial(plain)
                    </div>
                </div>
                 <div class="row">
                    <div class="col-md-3">
                    </div>
                    <div class="col-md-21">
                        b. Vial with anti coagulant solution.
                    </div>
                </div>
                
            </div>
            <div style="text-align: center" class="POuter_Box_Inventory">
                <asp:Button ID="btnSubmit" runat="server" CssClass="ItDoseButton save" Style="margin-top: 7px;" OnClick="btnSubmit_Click" Text="Save" />
            </div>
        </div>
    </form>
</body>
</html>
