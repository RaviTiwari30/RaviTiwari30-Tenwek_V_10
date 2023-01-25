<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PostOPvitalsEntry.aspx.cs" Inherits="Design_OT_PostOPvitalsEntry" %>

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
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css" />
    <form id="form1" runat="server">

        <script type="text/javascript">
            google.load('visualization', '1', { packages: ['corechart'] });
            google.load('visualization', '1', { packages: ['table'] });
         </script>

        <script type="text/javascript">
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

            function getgraph() {
                Bindgraph_Pulse("<%=Request.QueryString["TransactionID"]%>");
                Bindgraph_BP("<%=Request.QueryString["TransactionID"]%>");
             }

            function note1() {

                //  if ($.trim($("#<%=txtTemp.ClientID%>").val()) == "") {
                //      $("#<%=lblMsg.ClientID%>").text('Please Enter Patient Temperature');
                //      $("#<%=txtTemp.ClientID%>").focus();
                //       return false;
                //   } 
                if ($.trim($("#<%=txtPulse.ClientID%>").val()) == "") {
                    $("#<%=lblMsg.ClientID%>").text('Please Enter Patient Pulse');
                    $("#<%=txtPulse.ClientID%>").focus();
                    return false;
                }
                //    if ($.trim($("#<%=txtResp.ClientID%>").val()) == "") {
                //        $("#<%=lblMsg.ClientID%>").text('Please Enter Patient Resp');
                //         $("#<%=txtResp.ClientID%>").focus();
                //         return false;
                //     }


                //   if (Number($("#txtWeight").val()) <= 0) {
                //       $("#<%=lblMsg.ClientID%>").text('Please Enter Valid Weight');
                //        $("#<%=txtWeight.ClientID%>").focus();
                //       return false;
                //    }

                //    if (Number($("#txtHeight").val()) <= 0) {
                //        $("#<%=lblMsg.ClientID%>").text('Please Enter Patient Height');
                //         $("#<%=txtHeight.ClientID%>").focus();
                //        return false;
                //    }
                if ($.trim($("#<%=txtBP.ClientID%>").val()) == "") {
                    $("#<%=lblMsg.ClientID%>").text('Please Enter Patient B/P');
                    $("#<%=txtBP.ClientID%>").focus();
                    return false;
                }

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

                //  if ($.trim($("#<%=txtTemp.ClientID%>").val()) == "") {
                //      $("#<%=lblMsg.ClientID%>").text('Please Enter Patient Temperature');
                //      $("#<%=txtTemp.ClientID%>").focus();
                //       return false;
                //    }
                if ($.trim($("#<%=txtBP.ClientID%>").val()) == "") {
                    $("#<%=lblMsg.ClientID%>").text('Please Enter Patient B/P');
                    $("#<%=txtBP.ClientID%>").focus();
                    return false;
                }
                if ($.trim($("#<%=txtPulse.ClientID%>").val()) == "") {
                    $("#<%=lblMsg.ClientID%>").text('Please Enter Patient Pulse');
                    $("#<%=txtPulse.ClientID%>").focus();
                    return false;
                }
                //  if ($.trim($("#<%=txtResp.ClientID%>").val()) == "") {
                //        $("#<%=lblMsg.ClientID%>").text('Please Enter Patient Resp');
                //       $("#<%=txtResp.ClientID%>").focus();
                //       return false;
                //   }
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

            function Bindgraph_Pulse() {
                var TID = "<%=Request.QueryString["TransactionID"]%>";
                $.ajax({
                    url: "PostOPvitalsEntry.aspx/Bindgraph_Pulse",
                    data: '{TID:"' + TID + '"}',
                    type: "POST",
                    async: true,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (mydata) {
                        var mis_data = jQuery.parseJSON(mydata.d);
                        if (mis_data.length > 0) {
                            var dataTable = new google.visualization.DataTable();
                            dataTable.addColumn('string', 'CreatedTime');
                            dataTable.addColumn('number', 'Pulse');

                            dataTable.addRows(mis_data.length);
                            for (var i = 0; i < mis_data.length; i++) {
                                dataTable.setCell(i, 0, mis_data[i].CreatedTime);
                                dataTable.setCell(i, 1, mis_data[i].Pulse);
                            }

                            new google.visualization.ComboChart(document.getElementById('bindPulse_Area')).
                          draw(dataTable,
                               {
                                   title: 'Pulse Rate', fontName: '"Arial"',
                                   // width: 850,
                                   height: 400,

                                   hAxis: { title: "DateTime" },
                                   seriesType: "line",
                               }

                          );
                            $('#bindPulse_Area').show();
                        }
                        else
                            $('#bindPulse_Area').hide();
                    }
                });
            }

            function Bindgraph_BP() {
                var TID = "<%=Request.QueryString["TransactionID"]%>";
                $.ajax({
                    url: "PostOPvitalsEntry.aspx/Bindgraph_BP",
                    data: '{TID:"' + TID + '"}',
                    type: "POST",
                    async: true,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (mydata) {
                        var mis_data = jQuery.parseJSON(mydata.d);
                        if (mis_data.length > 0) {
                            var dataTable = new google.visualization.DataTable();
                            dataTable.addColumn('string', 'CreatedTime');
                            dataTable.addColumn('number', 'Systolic');
                            dataTable.addColumn('number', 'Diastolic');

                            dataTable.addRows(mis_data.length);
                            for (var i = 0; i < mis_data.length; i++) {
                                dataTable.setCell(i, 0, mis_data[i].CreatedTime);
                                dataTable.setCell(i, 1, mis_data[i].Systolic);
                                dataTable.setCell(i, 2, mis_data[i].Diastolic);
                            }

                            new google.visualization.ComboChart(document.getElementById('bindBP_Area')).
                          draw(dataTable,
                               {
                                   title: 'Blood Pressure', fontName: '"Arial"',
                                   // width: 850,
                                   height: 400,

                                   hAxis: { title: "DateTime" },
                                    seriesType: "line",
                                   //seriesType: "bars",
                               }

                          );
                            $('#bindBP_Area').show();
                        }
                        else
                            $('#bindBP_Area').hide();
                    }
                });
            }
        </script>


        <script type="text/javascript">
            var onCalculateBMI_AND_BSA = function () {
                var height = Number($("#txtHeight").val());
                var weight = Number($("#txtWeight").val());
                if (height > 0 && weight > 0) {
                    var bmi = weight / Math.pow((height * 0.01), 2);
                    var bsa = Math.sqrt(((height * weight) / 3600));
                    $("#lblBMI").text(precise_round(Number(bmi), 3));
                    $("#lblBSA").text(precise_round(Number(bsa), 3));
                    $("#txtBMI").val(precise_round(Number(bmi), 3));
                    $("#txtBSA").val(precise_round(Number(bsa), 3));
                }
                else {
                    $("#lblBMI").text('');
                    $("#lblBSA").text('');
                    $("#txtBMI").val('');
                    $("#txtBSA").val('');
                }

            }
        </script>

        <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>Post OP. Vitals Record</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                    Post OP. Vitals Record
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
                                <asp:TextBox ID="txtDate" CssClass="requiredField" runat="server" ReadOnly="true" Width="100px"></asp:TextBox>
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
                                <asp:TextBox ID="txtTime" runat="server" Width="100px"></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTime"
                                    Mask="99:99" MaskType="Time" AcceptAMPM="true" />

                                <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtTime"
                                    ControlExtender="MaskedEditExtender1" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                    InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                                <br />
                                <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                            </div>
                            <div style="display:none">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Temp
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtTemp" CssClass="requiredField" runat="server" Width="70px"></asp:TextBox>
                                <sup><span>0</span></sup>C
                                <asp:RadioButtonList CssClass="requiredField" ID="rdbtempunit" runat="server" RepeatDirection="Horizontal" Visible="false">
                                    <%--<asp:ListItem Value="F"><sup><span class="auto-style7">0</span></sup>F</asp:ListItem>--%>
                                    <asp:ListItem Value="C" Selected="True"><sup><span class="auto-style7">0</span></sup>C</asp:ListItem>
                                </asp:RadioButtonList>
                            </div>
                                </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    B/P
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtBP" CssClass="requiredField" runat="server" Width="70px"></asp:TextBox>
                                <span class="auto-style7">mm/Hg</span><asp:Label ID="Label6" runat="server" Style="color: Red;" CssClass="auto-style7"></asp:Label>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Pulse
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtPulse" CssClass="requiredField" runat="server" Width="70px"></asp:TextBox>
                                <span class="auto-style7">ppm</span>
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
                        </div>
                        <div class="row" style="display:none">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Wounds
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtwounds" runat="server" Width="70px"></asp:TextBox>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Drains
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtDrains" runat="server" Width="70px"></asp:TextBox>
                                ml
                            </div>
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
                        </div>
                        <div class="row" style="display:none">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Weight
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtWeight"  onkeyup="onCalculateBMI_AND_BSA();" ClientIDMode="Static" onlynumber="10" decimalplace="4" max-value="10000" runat="server" Width="70px"></asp:TextBox>
                                kg
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    P.O.D 
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:TextBox ID="txtPOD" runat="server" Width="70px"></asp:TextBox>Days
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
                        </div>
                        <div class="row" style="display:none">
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

                <asp:Button ID="Btnsave" ClientIDMode="Static" runat="server" OnClick="btnSave_Click" Text="save" CssClass="ItDoseButton" OnClientClick="return note();" />
                <%--<asp:Button ID="btnUpdate" ClientIDMode="Static" runat="server" Text="Update" Visible="false" CssClass="ItDoseButton" TabIndex="69" OnClientClick="return note1();" OnClick="btnUpdate_Click" />--%>
                <asp:Button ID="btnUpdate" ClientIDMode="Static" runat="server" Text="Update" Visible="false" CssClass="ItDoseButton" TabIndex="69" OnClientClick="return note();" OnClick="btnUpdate_Click" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="ItDoseButton" TabIndex="69" Visible="false" OnClick="btnCancel_Click" />
                <asp:Button ID="btnPrint" runat="server" Text="Print" CssClass="ItDoseButton" TabIndex="69" OnClick="btnPrint_Click" Visible="false" />
                <button type="button" id="btnGraph" onclick="getgraph()"  style="width:90px">View Graph</button>
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
                                        <asp:TemplateField HeaderText="Temperature" Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="lblTemp" runat="server" Text='<%# Eval("Temp") %>'></asp:Label>
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
                                        <asp:TemplateField HeaderText="Pulse">
                                            <ItemTemplate>
                                                <asp:Label ID="lblPulse" runat="server" Text='<%#Eval("Pulse") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Resp." Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="lblresp" runat="server" Text='<%#Eval("Resp") %>'></asp:Label>
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
                                        <asp:TemplateField HeaderText="Blood Sugar" Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="lblBoodSugar" runat="server" Text='<%#Eval("BloodSugar") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Weight" Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="lblWeight" runat="server" Text='<%#Eval("Weight") %>'></asp:Label>
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
                                        <asp:TemplateField HeaderText="SPO2">
                                            <ItemTemplate>
                                                <asp:Label ID="lblOxygen" runat="server" Text='<%#Eval("Oxygen") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Height" Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="lblHeight" runat="server" Text='<%#Eval("Height") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="BMI" Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="lblBMI" runat="server" Text='<%#Eval("BMI") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="BSA" Visible="false">
                                            <ItemTemplate>
                                                <asp:Label ID="lblBSA" runat="server" Text='<%#Eval("BSA") %>'></asp:Label>
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
            <div id="printData">
                   <div class="POuter_Box_Inventory">
                        <div class="Purchaseheader">Blood Pressure</div>
                        <table style="width:100%">
                             <tr>
                                <td style="width: 50%">
                                    <div id="bindBP_Area">
                                    </div>
                                </td>                           
                            </tr>
                       </table>
                    </div>
                   <div class="POuter_Box_Inventory">
                            <div class="Purchaseheader">Pulse Rate</div>
                            <table style="width:100%">
                                 <tr>
                                    <td style="width: 50%">
                                        <div id="bindPulse_Area">
                                        </div>
                                    </td>                           
                                </tr>
                           </table>
                    </div>                    
             </div>
        </div>
    </form>

</body>
</html>