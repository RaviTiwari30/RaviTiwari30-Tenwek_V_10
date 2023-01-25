<%@ Page Language="C#" AutoEventWireup="true" CodeFile="IPD_Patient_ObservationChart.aspx.cs" Inherits="Design_IPD_IPD_Patient_ObservationChart" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <%-- <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <script type="text/javascript" src="../../Scripts/jquery-1.7.1.min.js"></script>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>--%>


    <style type="text/css">
        .auto-style4 {
            width: 91px;
            height: 16px;
        }

        .auto-style5 {
            width: 456px;
            height: 16px;
        }

        .auto-style7 {
            font-size: 8pt;
        }

        .auto-style8 {
            width: 91px;
        }

        .auto-style9 {
            width: 456px;
        }

        .auto-style10 {
            width: 62px;
        }
    </style>
</head>

<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../../Scripts/shortcut.js"></script>
    <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css" />
    <form id="form1" runat="server">
        <script type="text/javascript">
            $(document).ready(function () {
                $('#<%=ddlWeightUnit.ClientID %>').change(function () {
                    onCalculateBMI_AND_BSA();
                });
            });
            if ($.browser.msie) {
                $(document).on("keydown", function (e) {
                    var doPrevent;
                    if (e.keyCode == 8) {
                        var d = e.srcElement || e.target;
                        if (d.tagName.toUpperCase() == 'INPUT' || d.tagName.toUpperCase() == 'TEXTAREA') {
                            doPrevent = d.readOnly
                                || d.disabled;
                        }
                        else
                            doPrevent = true;
                    }
                    else
                        doPrevent = false;
                    if (doPrevent) {
                        e.preventDefault();
                    }
                });
            }


        </script>
        <script type="text/javascript">
          

            function note1() {

                if ($.trim($("#<%=txtTemp.ClientID%>").val()) == "") {
                    $("#<%=lblMsg.ClientID%>").text('Please Enter Patient Temperature');
                    $("#<%=txtTemp.ClientID%>").focus();
                    return false;
                }
                if ($.trim($("#<%=txtPulse.ClientID%>").val()) == "") {
                    $("#<%=lblMsg.ClientID%>").text('Please Enter Patient Pulse');
                    $("#<%=txtPulse.ClientID%>").focus();
                    return false;
                }
                if ($.trim($("#<%=txtResp.ClientID%>").val()) == "") {
                    $("#<%=lblMsg.ClientID%>").text('Please Enter Patient Resp');
                    $("#<%=txtResp.ClientID%>").focus();
                    return false;
                }


                if (Number($("#txtWeight").val()) <= 0) {
                    $("#<%=lblMsg.ClientID%>").text('Please Enter Valid Weight');
                    $("#<%=txtWeight.ClientID%>").focus();
                    return false;
                }

                if (Number($("#txtHeight").val()) <= 0) {
                    $("#<%=lblMsg.ClientID%>").text('Please Enter Patient Height');
                      $("#<%=txtHeight.ClientID%>").focus();
                      return false;
                }




                //  if ($.trim($("#<%=txtBP.ClientID%>").val()) == "") {
                //     $("#<%=lblMsg.ClientID%>").text('Please Enter Patient B/P');
                //     $("#<%=txtBP.ClientID%>").focus();
                //     return false;
                // }

                var bp = $('#<%=txtBP.ClientID %>').val();
                var bpexp = /[A-Z0-9._%+-]+\/[A-Z0-9.-]/;
                if ($('#<%=txtBP.ClientID %>').val() != "") {
                    if (!bpexp.test(bp)) {
                        alert('Please enter valid Bp ');
                        $('#<%=txtBP.ClientID %>').focus();
                        return false;
                    }

                }
                __doPostBack('btnUpdate', '');

            }

            function note() {

                if ($.trim($("#<%=txtTemp.ClientID%>").val()) == "") {
                      $("#<%=lblMsg.ClientID%>").text('Please Enter Patient Temperature');
                    $("#<%=txtTemp.ClientID%>").focus();
                    return false;
                }
                if ($.trim($("#<%=txtPulse.ClientID%>").val()) == "") {
                      $("#<%=lblMsg.ClientID%>").text('Please Enter Patient Pulse');
                    $("#<%=txtPulse.ClientID%>").focus();
                    return false;
                }
                if ($.trim($("#<%=txtResp.ClientID%>").val()) == "") {
                      $("#<%=lblMsg.ClientID%>").text('Please Enter Patient Resp');
                    $("#<%=txtResp.ClientID%>").focus();
                    return false;
                }

                if (Number($("#txtWeight").val()) <= 0) {
                    $("#<%=lblMsg.ClientID%>").text('Please Enter Valid Weight');
                    $("#<%=txtWeight.ClientID%>").focus();
                    return false;
                }
                if (Number($("#txtHeight").val()) <= 0) {
                    $("#<%=lblMsg.ClientID%>").text('Please Enter Patient Height');
                    $("#<%=txtHeight.ClientID%>").focus();
                    return false;
                }
                  //  if ($.trim($("#<%=txtBP.ClientID%>").val()) == "") {
                  //     $("#<%=lblMsg.ClientID%>").text('Please Enter Patient B/P');
                  //     $("#<%=txtBP.ClientID%>").focus();
                  //     return false;
                  // }

                  var bp = $('#<%=txtBP.ClientID %>').val();
                  var bpexp = /[A-Z0-9._%+-]+\/[A-Z0-9.-]/;
                  if ($('#<%=txtBP.ClientID %>').val() != "") {
                    if (!bpexp.test(bp)) {
                        alert('Please enter valid Bp ');
                        $('#<%=txtBP.ClientID %>').focus();
                        return false;
                    }

                }
                __doPostBack('Btnsave', '');

            }
          //  function bp() {
           //     var bp = $('#<%=txtBP.ClientID %>').val();
           //     var bpexp = /[A-Z0-9._%+-]+\/[A-Z0-9.-]/;
           //     if ($('#<%=txtBP.ClientID %>').val() != "") {
           //         if (!bpexp.test(bp)) {
            //            alert('Please enter valid Bp ');
            //            $('#<%=txtBP.ClientID %>').focus();
            //            return false;
             //       }

            //    }
            // }

            $(function () {
                $("#txtPOD,txtTemp").keypress(function (e) {
                    var charCode = (e.which) ? e.which : e.keyCode;
                    if (charCode != 8 && charCode != 0 && (charCode < 48 || charCode > 57)) {
                        return false;
                    }
                });
            });
        </script>


        <script type="text/javascript">
            var onCalculateBMI_AND_BSA = function () {
                var height = Number($("#txtHeight").val());
                var weight = Number($("#txtWeight").val());
                if ($('#<%=ddlWeightUnit.ClientID %>').val() == "Gram") {
                    weight = weight / 1000;
                }
                var bmi = weight / Math.pow((height * 0.01), 2);
                var bsa = Math.sqrt(((height * weight) / 3600));
                $("#lblBMI").text(precise_round(Number(bmi), 3));
                $("#lblBSA").text(precise_round(Number(bsa), 3));
                $("#txtBMI").val(precise_round(Number(bmi), 3));
                $("#txtBSA").val(precise_round(Number(bsa), 3));
            }
            var onCalculateGCA = function () {
                var E = Number($("#txtE").val());
                var M = Number($("#txtM").val());
                var V = Number($("#txtV").val());
                var GCS = E + M + V;

                $('#lblGCS').text(GCS);
                $('#txtGCS').val(GCS);

            }

            function Incubation() {
                
                if ($('#chkIncubation').is(':checked') ) {
                    $('#lblincubation').text('T');
                    $('#txtIncubation').val('1');
                }
                else {
                    $('#lblincubation').text('');
                    $('#txtIncubation').val('0');
                }
            }
        </script>

        <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>Observation Chart </b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                    Observation Chart
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Date
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtDate" CssClass="requiredField" runat="server" ReadOnly="true" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="txtDate"
                                    Format="dd-MMM-yyyy" ClearTime="true">
                                </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Time
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtTime" runat="server" Width="100px"  ClientIDMode="Static" ></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTime"
                                    Mask="99:99" MaskType="Time" AcceptAMPM="true" />

                                <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtTime"
                                    ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                    InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                                <br />
                                <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Temp
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtTemp"  runat="server" Width="70px"></asp:TextBox>
                                <sup><span>0</span></sup>C
                                <asp:RadioButtonList CssClass="requiredField" ID="rdbtempunit" runat="server" RepeatDirection="Horizontal" Visible="false">
                                    <%--<asp:ListItem Value="F"><sup><span class="auto-style7">0</span></sup>F</asp:ListItem>--%>
                                    <asp:ListItem Value="C" Selected="True"><sup><span class="auto-style7">0</span></sup>C</asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Pulse
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtPulse" runat="server" Width="70px"></asp:TextBox>
                                <span class="auto-style7">ppm</span>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Resp
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtResp" runat="server" Width="70px"></asp:TextBox>
                                <span class="auto-style7">Rate/Min</span>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    B/P
                                    <span class="auto-style7">(mm/Hg)</span><asp:Label ID="Label6" runat="server" Style="color: Red;" CssClass="auto-style7"></asp:Label>
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtBP" runat="server" Width="70px"></asp:TextBox>
                                
                                 <asp:DropDownList ID="ddlInvasiveNonInvasive" runat="server" Width="100px">
                                    <asp:ListItem Value="Invasive">Invasive</asp:ListItem>
                                    <asp:ListItem Value="NonInvasive" Selected="True">NonInvasive</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="row">
                            
                            <div class="col-md-3">
                                <label class="pull-left">
                                    BloodSugar
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtBloodSugar" runat="server" Width="70px"></asp:TextBox>
                                mmol/L
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    SPO2
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtOxygen" runat="server" Width="70px"></asp:TextBox>
                                %
                            </div>
                              <div class="col-md-3">
                            <label class="pull-left">
                                    Oxygen Flow
                                </label>
                                <b class="pull-right">:</b>
                                </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtOxygenFlow"  ClientIDMode="Static"  runat="server" ></asp:TextBox>
                            </div>
                        </div>
                        <div class="row" style="display:none">
                           
                            <div class="col-md-3" style="display:none">
                                <label class="pull-left">
                                    P.O.D 
                                </label>
                                <b class="pull-right" style="display:none">:</b>
                            </div>
                            <div class="col-md-5" style="display:none">
                                <asp:TextBox ID="txtPOD" runat="server" Width="70px"></asp:TextBox>&nbsp;Days
                            </div>
                          
                            <div class="col-md-3" style="display:none">
                                <label class="pull-left">
                                    Wounds
                                </label>
                                <b class="pull-right"style="display:none">:</b>
                            </div>
                            <div class="col-md-5" style="display:none">
                                <asp:TextBox ID="txtwounds" runat="server" Width="70px"></asp:TextBox>
                            </div>
                            <div class="col-md-3" style="display:none">
                                <label class="pull-left">
                                    Drains
                                </label>
                                <b class="pull-right" style="display:none">:</b>
                            </div>
                            <div class="col-md-5" style="display:none">
                                <asp:TextBox ID="txtDrains" runat="server" Width="70px"></asp:TextBox>
                                ml
                            </div>
                        </div>





                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Height
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtHeight"  ClientIDMode="Static" onkeyup="onCalculateBMI_AND_BSA();" onlynumber="10" decimalplace="4" max-value="10000" runat="server" Width="70px"></asp:TextBox>
                                CM
                            </div>
                           <div class="col-md-3">
                                <label class="pull-left">
                                    Weight
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtWeight"  onkeyup="onCalculateBMI_AND_BSA();" ClientIDMode="Static" onlynumber="10" decimalplace="4" max-value="10000" runat="server" Width="70px"></asp:TextBox>
                                <asp:DropDownList ID="ddlWeightUnit" runat="server" Width="100px">
                                    <asp:ListItem Value="Kg" Selected="True">Kg</asp:ListItem>
                                    <asp:ListItem Value="Gram" >Gram</asp:ListItem>
                                </asp:DropDownList>

                            </div>
                             <div class="col-md-3">
                            <label class="pull-left">
                                    Head Circ.
                                </label>
                                <b class="pull-right">:</b>
                                </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtHeadCircumference"  ClientIDMode="Static"  runat="server" ></asp:TextBox>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-3">
                            <label class="pull-left">
                                    E
                                </label>
                                <b class="pull-right">:</b>
                                </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtE"  ClientIDMode="Static"  onlynumber="10" decimalplace="4" max-value="10000" runat="server" Width="70px" onkeyup="onCalculateGCA();"></asp:TextBox>
                            </div>
                             <div class="col-md-3">
                            <label class="pull-left">
                                    M
                                </label>
                                <b class="pull-right">:</b>
                                </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtM"  ClientIDMode="Static"  onlynumber="10" decimalplace="4" max-value="10000" runat="server" Width="70px" onkeyup="onCalculateGCA();"></asp:TextBox>
                            </div>
                             <div class="col-md-3">
                            <label class="pull-left">
                                    V
                                </label>
                                <b class="pull-right">:</b>
                                </div>
                            <div class="col-md-2">
                                <asp:TextBox ID="txtV"  ClientIDMode="Static"  onlynumber="10" decimalplace="4" max-value="10000" runat="server" Width="70px" onkeyup="onCalculateGCA();"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                
                                <asp:CheckBox id="chkIncubation" runat="server" ToolTip="Intubation" ClientIDMode="Static" onclick="Incubation();" value="1"/> Intubation
                            </div>
                 
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                            <label class="pull-left">
                                    GCS
                                </label>
                                <b class="pull-right">:</b>
                                </div>
                            <div class="col-md-5">
                                <asp:Label ID="lblGCS" runat="server" ToolTip="GCS" ClientIDMode="Static"  CssClass="ItDoseLblError"  ></asp:Label>
                                <asp:TextBox ID="txtGCS" ClientIDMode="Static" runat="server" style="display:none;"></asp:TextBox>
                                <asp:Label ID="lblincubation" runat="server" ToolTip="GCS" ClientIDMode="Static"  CssClass="ItDoseLblError"  ></asp:Label>
                                <asp:TextBox ID="txtIncubation" ClientIDMode="Static" runat="server" style="display:none;"></asp:TextBox>
                            </div>
                           
                           <div class="col-md-3">
                                <label class="pull-left">
                                    BMI
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="lblBMI" CssClass="ItDoseLblError" ClientIDMode="Static" Width="70px" runat="server"></asp:Label>
                                kg/m&#178
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    BSA
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:Label ID="lblBSA" CssClass="ItDoseLblError" ClientIDMode="Static" Width="70px" runat="server"></asp:Label>
                                m&#178

                                 <asp:TextBox ID="txtBMI" ClientIDMode="Static" runat="server" style="display:none;"></asp:TextBox>
                              
                                 <asp:TextBox ID="txtBSA" ClientIDMode="Static" runat="server" style="display:none;"></asp:TextBox>
                              
                            </div>
                        </div>




                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Comments
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-16">
                                <asp:TextBox ID="txtComment" runat="server" TextMode="MultiLine" Height="50px"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <asp:Label ID="lblID" runat="server" Visible="false"></asp:Label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center">

                <asp:Button ID="Btnsave" ClientIDMode="Static" runat="server" OnClick="btnSave_Click" Text="save" CssClass="ItDoseButton"/> <%--OnClientClick="return note();" --%>
                <asp:Button ID="btnUpdate" ClientIDMode="Static" runat="server" Text="Update" Visible="false" CssClass="ItDoseButton" TabIndex="69"  OnClick="btnUpdate_Click" /><%--OnClientClick="return note1();"--%>
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="ItDoseButton" TabIndex="69" Visible="false" OnClick="btnCancel_Click" />
                <asp:Button ID="btnPrint" runat="server" Text="Print" CssClass="ItDoseButton" TabIndex="69" OnClick="btnPrint_Click" />
            </div>

            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="height: 19px;">
                    Results
                </div>
                <table id="tbNursingprogress">
                    <tr>
                        <td>
                            <div style="text-align: center;">
                                <asp:GridView ID="grdNursing" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowDataBound="grdNursing_RowDataBound" OnRowCommand="grdNursing_RowCommand" OnPageIndexChanging="OnPageIndexChanging" AllowPaging="true" PagerSettings-PageButtonCount="5">

                                    <Columns>
                                        <asp:TemplateField HeaderText="S.No." ItemStyle-CssClass="GridViewItemStyle" HeaderStyle-Width="20px" ItemStyle-Width="20px" HeaderStyle-CssClass="GridViewHeaderStyle">
                                            <ItemTemplate>
                                                <%# Container.DataItemIndex+1 %>
                                            </ItemTemplate>

                                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px"></HeaderStyle>

                                            <ItemStyle CssClass="GridViewItemStyle" Width="20px"></ItemStyle>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Date">
                                            <ItemTemplate>
                                                <asp:Label ID="lbldate" runat="server" Text='<%#Eval("Date") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Time">
                                            <ItemTemplate>
                                                <asp:Label ID="lblTime" runat="server" Text='<%#Eval("Time") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Temperature">
                                            <ItemTemplate>
                                                <asp:Label ID="lblTemp" runat="server" Text='<%# Eval("Temp") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Pulse">
                                            <ItemTemplate>
                                                <asp:Label ID="lblPulse" runat="server" Text='<%#Eval("Pulse") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Resp.">
                                            <ItemTemplate>
                                                <asp:Label ID="lblresp" runat="server" Text='<%#Eval("Resp") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="B/P">
                                            <ItemTemplate>
                                                <asp:Label ID="lblBP" runat="server" Text='<%#Eval("BP") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Inv./Non Inv.">
                                            <ItemTemplate>
                                                <asp:Label ID="lblInvasiveNonInvasive" runat="server" Text='<%#Eval("InvasiveNonInvasivebind") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Wounds" Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="lblwounds" runat="server" Text='<%#Eval("Wound") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Drains" Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="lbldrains" runat="server" Text='<%#Eval("Drains") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Blood Sugar">
                                            <ItemTemplate>
                                                <asp:Label ID="lblBoodSugar" runat="server" Text='<%#Eval("BloodSugar") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Weight">
                                            <ItemTemplate>
                                                <asp:Label ID="lblWeight" runat="server" Text='<%#Eval("Weight") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        
                                        <asp:TemplateField HeaderText="Wt. Unit">
                                            <ItemTemplate>
                                                <asp:Label ID="lblWeightUnit" runat="server" Text='<%#Eval("WeightUnit") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="P.O.D" Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="lblPOD" runat="server" Text='<%#Eval("POD") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Oxygen">
                                            <ItemTemplate>
                                                <asp:Label ID="lblOxygen" runat="server" Text='<%#Eval("Oxygen") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                         <asp:TemplateField HeaderText="Oxygen Flow">
                                            <ItemTemplate>
                                                <asp:Label ID="lblOxygenFlow" runat="server" Text='<%#Eval("OxygenFlow") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Height">
                                            <ItemTemplate>
                                                <asp:Label ID="lblHeight" runat="server" Text='<%#Eval("Height") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="BMI">
                                            <ItemTemplate>
                                                <asp:Label ID="lblBMI" runat="server" Text='<%#Eval("BMI") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="BSA">
                                            <ItemTemplate>
                                                <asp:Label ID="lblBSA" runat="server" Text='<%#Eval("BSA") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                          <asp:TemplateField HeaderText="E">
                                            <ItemTemplate>
                                                <asp:Label ID="lblE" runat="server" Text='<%#Eval("E") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                          <asp:TemplateField HeaderText="M">
                                            <ItemTemplate>
                                                <asp:Label ID="lblM" runat="server" Text='<%#Eval("M") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                          <asp:TemplateField HeaderText="V">
                                            <ItemTemplate>
                                                <asp:Label ID="lblV" runat="server" Text='<%#Eval("V") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                         <asp:TemplateField HeaderText="GCS">
                                            <ItemTemplate>
                                                <asp:Label ID="lblGCS" runat="server" Text='<%#Eval("GCS") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                         <asp:TemplateField HeaderText="Head Circ.">
                                            <ItemTemplate>
                                                <asp:Label ID="lblHead" runat="server" Text='<%#Eval("Headcircumference") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                           <asp:TemplateField HeaderText="Intubation">
                                            <ItemTemplate>
                                                <asp:Label ID="lblIncubation" runat="server" Text='<%#Eval("Incubation") %>' Visible="false"></asp:Label>
                                                <asp:Label ID="Label1" runat="server" Text='<%#Eval("Incubation1") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Comments">
                                            <ItemTemplate>
                                                <asp:Label ID="lblComments" runat="server" Text='<%#Eval("Comments") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Entry By">
                                            <ItemTemplate>
                                                <asp:Label ID="lblCreatedBy" runat="server" Text='<%#Eval("EmpName") %>'></asp:Label>
                                                <asp:Label ID="lblCreatedID" runat="server" Text='<%#Eval("CreatedBy") %>' Visible="false"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Edit">
                                            <ItemTemplate>
                                                <asp:ImageButton ID="imgbtnEdit" AlternateText="Edit" CommandName="Change" CommandArgument='<%#Container.DataItemIndex%>' ImageUrl="~/Images/edit.png" runat="server" />
                                                <asp:Label ID="lblUserID" Text='<%#Eval("CreatedBy") %>' runat="server" Visible="false"></asp:Label>
                                                <asp:Label ID="lblID" Text='<%#Eval("ID") %>' runat="server" Visible="false"></asp:Label>
                                                <asp:Label ID="lblTimeDiff" Text='<%#Eval("createdDateDiff") %>' runat="server" Visible="false"></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>

                                    </Columns>
                                    <PagerSettings FirstPageText="First" LastPageText="Last" Mode="NumericFirstLast" PageButtonCount="5" />
                                </asp:GridView>
                            </div>

                        </td>
                    </tr>
                </table>
            </div>

        </div>
    </form>

</body>
</html>

