<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Partograph.aspx.cs" Inherits="Design_IPD_Partograph" %>

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
            function note() {

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

                if ($.trim($("#<%=txtTemp.ClientID%>").val()) == "") {
                    $("#<%=lblMsg.ClientID%>").text('Please Enter Patient Temperature');
                    $("#<%=txtTemp.ClientID%>").focus();
                    return false;
                }    

                var bp = $('#<%=txtBP.ClientID %>').val();
                var bpexp = /[A-Z0-9._%+-]+\/[A-Z0-9.-]/;
                if ($('#<%=txtBP.ClientID %>').val() != "") {
                    if (!bpexp.test(bp)) {
                        alert('Please enter valid BP ');
                        $('#<%=txtBP.ClientID %>').focus();
                        return false;
                    }

                }
                __doPostBack('btnUpdate', '');

            }

            //$(function () {
            //    $("#txtTemp").keypress(function (e) {
            //        var charCode = (e.which) ? e.which : e.keyCode;
            //        if (charCode != 8 && charCode != 0 && (charCode < 48 || charCode > 57)) {
            //            return false;
            //        }
            //    });
            //});
        </script>

        <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Partograph Chart </b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                    Partograph Chart
                </div>
                <div class="row">
                    <div class="col-md-24">
                        <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left">
                                    Date of Ruptured Membranes
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                               <%-- <asp:TextBox ID="txtDate" CssClass="requiredField" runat="server" ReadOnly="true"></asp:TextBox> --%>
                                 <asp:TextBox ID="txtDate" runat="server" ReadOnly="true"></asp:TextBox> 
                                <cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy" ClearTime="true"> </cc1:CalendarExtender>
                            </div>
                            <div class="col-md-6">
                                <label class="pull-left">
                                    Time of Ruptured Membranes
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtTime" runat="server"></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTime" Mask="99:99" MaskType="Time" AcceptAMPM="true" />
                                <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtTime" ControlExtender="MaskedEditExtender1" IsValidEmpty="true" 
                                     EmptyValueMessage="Time Required" InvalidValueMessage="Invalid Time" ValidationGroup="save1">
                                </cc1:MaskedEditValidator>                                
                             </div>
                              <div class="col-md-5">
                                  <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                              </div>                                
                          </div>                         
                        <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left">
                                    Date at Dilation
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtDilationDate" runat="server" ReadOnly="true"></asp:TextBox>
                                <cc1:CalendarExtender ID="clcDilation" runat="server" TargetControlID="txtDilationDate" Format="dd-MMM-yyyy" ClearTime="true"></cc1:CalendarExtender>
                             </div>
                            <div class="col-md-6">
                                <label class="pull-left">
                                    Time at Dilation
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-3">
                                <asp:TextBox ID="txtDilationTime" runat="server" ></asp:TextBox>
                                <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDilationTime" Mask="99:99" MaskType="Time" AcceptAMPM="true" />
                                <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlToValidate="txtDilationTime" ControlExtender="MaskedEditExtender2"
                                     IsValidEmpty="true" EmptyValueMessage="Time Required" InvalidValueMessage="Invalid Time" ValidationGroup="save1">
                                </cc1:MaskedEditValidator>                               
                             </div>
                             <div class="col-md-5">
                                  <em><span style="color: #0000ff; font-size: 7.5pt">(Type A or P to switch AM/PM)</span></em>
                              </div>
                        </div>
                        <div class="row">
                             <div class="col-md-6">
                                 <label class="pull-left">
                                    Gravida
                                </label>
                                <b class="pull-right">:</b>
                             </div>
                            <div class="col-md-4">
                                 <asp:TextBox ID="txtGravida" runat="server" MaxLength="15" onkeypress="return (event.charCode >= 48 && event.charCode <= 57 || event.charCode >= 46 && event.charCode <= 48 )" ></asp:TextBox>
                             </div>
                            <div class="col-md-6">
                                <label class="pull-left">
                                    Para
                                </label>
                                <b class="pull-right">:</b>
                             </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtPara" runat="server"  MaxLength="15" onkeypress="return (event.charCode >= 48 && event.charCode <= 57 || event.charCode >= 46 && event.charCode <= 48 )" ></asp:TextBox>
                            </div>
                          </div>
                         <div class="row">
                             <div class="col-md-6">
                                <label class="pull-left">
                                    Fetal Heart Rate
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtFHR" runat="server"  MaxLength="6" onkeypress="return (event.charCode >= 48 && event.charCode <= 57 || event.charCode >= 46 && event.charCode <= 48 )" ></asp:TextBox>
                            </div>
                             <div class="col-md-6">
                                <label class="pull-left">
                                    Temp
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtTemp"  runat="server" MaxLength="6" onkeypress="return (event.charCode >= 48 && event.charCode <= 57 || event.charCode >= 46 && event.charCode <= 48 )" ></asp:TextBox>
                             </div>
                            <div class="col-md-2">
                                <sup><span>0</span></sup>C                                
                            </div>   
                        </div>
                         <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left">
                                    B/P (mm/Hg)
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtBP" runat="server" placeholder="mm/Hg" MaxLength="8" onkeypress="return (event.charCode >= 48 && event.charCode <= 57 || event.charCode >= 46 && event.charCode <= 48 )"></asp:TextBox>
                             </div>                            
                            <div class="col-md-6">
                                <label class="pull-left">
                                    Pulse
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:TextBox ID="txtPulse" runat="server" MaxLength="6" onkeypress="return (event.charCode >= 48 && event.charCode <= 57 || event.charCode >= 46 && event.charCode <= 48 )" ></asp:TextBox>
                             </div>
                            <div class="col-md-2">
                                <span class="auto-style7">pm</span>
                            </div>                                        
                        </div>
                         <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left">
                                    Amniotic Fluid
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                 <asp:DropDownList ID="ddlAmnioticFluid" runat="server">
                                     <asp:ListItem Text="Select" Value="Select"></asp:ListItem>
                                     <asp:ListItem Text="Absent" Value="Absent"></asp:ListItem>
                                     <asp:ListItem Text="Clear" Value="Clear"></asp:ListItem>
                                     <asp:ListItem Text="Blood Stained" Value="Blood Stained"></asp:ListItem>
                                     <asp:ListItem Text="Meconium Stained 1+" Value="Meconium Stained 1+"></asp:ListItem>
                                     <asp:ListItem Text="Slightly Thick Meconium 2+" Value="Slightly Thick Meconium 2+"></asp:ListItem>
                                     <asp:ListItem Text="Meconium Very Thick 3+" Value="Meconium Very Thick 3+"></asp:ListItem>                                    
                                 </asp:DropDownList>
                             </div>
                             <div class="col-md-6">
                                <label class="pull-left">
                                    Moulding
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                             <div class="col-md-4">
                                  <asp:DropDownList ID="ddlMoulding" runat="server">
                                      <asp:ListItem Text="Select" Value="Select"></asp:ListItem>
                                      <asp:ListItem Text="0 Sutures Seperate" Value="0 Sutures Seperate"></asp:ListItem>
                                      <asp:ListItem Text="1 Sutures Apposed" Value="1 Sutures Apposed"></asp:ListItem>
                                      <asp:ListItem Text="2 Sutures Overlap But Reducible" Value="2 Sutures Overlap But Reducible"></asp:ListItem>
                                      <asp:ListItem Text="3 Sutures Overlap Not Reducible" Value="3 Sutures Overlap Not Reducible"></asp:ListItem>
                                 </asp:DropDownList>
                              </div>
                          </div>
                          <div class="row" runat="server" id="divCervixDescent">
                              <div class="col-md-6">
                                <label class="pull-left">
                                   Cervix
                                </label>
                                <b class="pull-right">:</b>
                               </div>
                               <div class="col-md-4">
                                     <asp:DropDownList ID="ddlCervix" runat="server">
                                         <asp:ListItem Text="Select" Value="Select"></asp:ListItem>
                                         <asp:ListItem Text="0" Value="0"></asp:ListItem>
                                         <asp:ListItem Text="1" Value="1"></asp:ListItem>
                                         <asp:ListItem Text="2" Value="2"></asp:ListItem>
                                         <asp:ListItem Text="3" Value="3"></asp:ListItem>
                                         <asp:ListItem Text="4" Value="4"></asp:ListItem>
                                         <asp:ListItem Text="5" Value="5"></asp:ListItem>
                                         <asp:ListItem Text="6" Value="6"></asp:ListItem>
                                         <asp:ListItem Text="7" Value="7"></asp:ListItem>
                                         <asp:ListItem Text="8" Value="8"></asp:ListItem>
                                         <asp:ListItem Text="9" Value="9"></asp:ListItem>
                                         <asp:ListItem Text="10" Value="10"></asp:ListItem>
                                     </asp:DropDownList>
                                </div>
                              <div class="col-md-6">
                                <label class="pull-left">
                                   Descent
                                </label>
                                <b class="pull-right">:</b>
                               </div>
                               <div class="col-md-4">
                                   <asp:DropDownList ID="ddlDescent" runat="server">
                                         <asp:ListItem Text="Select" Value="Select"></asp:ListItem>
                                         <asp:ListItem Text="0" Value="0"></asp:ListItem>
                                         <asp:ListItem Text="1" Value="1"></asp:ListItem>
                                         <asp:ListItem Text="2" Value="2"></asp:ListItem>
                                         <asp:ListItem Text="3" Value="3"></asp:ListItem>
                                         <asp:ListItem Text="4" Value="4"></asp:ListItem>
                                         <asp:ListItem Text="5" Value="5"></asp:ListItem>
                                   </asp:DropDownList>
                               </div>
                               <div class="col-md-2">
                                   <span class="auto-style7">/5</span>
                               </div>                               
                          </div>
                          <div class="row">
                              <div class="col-md-6">
                                <label class="pull-left">
                                   Contractions (in 10 mins)
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                     <asp:DropDownList ID="ddlContractions" runat="server">
                                         <asp:ListItem Text="Select" Value="Select"></asp:ListItem>
                                         <asp:ListItem Text="1" Value="1"></asp:ListItem>
                                         <asp:ListItem Text="2" Value="2"></asp:ListItem>
                                         <asp:ListItem Text="3" Value="3"></asp:ListItem>
                                         <asp:ListItem Text="4" Value="4"></asp:ListItem>
                                         <asp:ListItem Text="5" Value="5"></asp:ListItem>
                                         <asp:ListItem Text="6" Value="6"></asp:ListItem>
                                   </asp:DropDownList>                            
                            </div>
                             <div class="col-md-6">
                                <label class="pull-left">
                                   Lasting
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                <asp:DropDownList ID="ddlContraLasting" runat="server">
                                         <asp:ListItem Text="Select" Value="Select"></asp:ListItem>
                                         <asp:ListItem Text="< 20 secs" Value="< 20 secs"></asp:ListItem>
                                         <asp:ListItem Text="20 to 40" Value="20 to 40"></asp:ListItem>
                                         <asp:ListItem Text="> 40" Value="> 40"></asp:ListItem>                                        
                                   </asp:DropDownList>                                 
                            </div>
                            <div class="col-md-2">
                                <span class="auto-style7">Secs</span>
                            </div>
                        </div>                          
                        <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left">
                                    Oxytocin (Units /500ml)
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                               <asp:TextBox ID="txtOxyinML" runat="server" onkeypress="return (event.charCode >= 48 && event.charCode <= 57 || event.charCode >= 46 && event.charCode <= 48 )"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label class="pull-left">
                                    At
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                 <asp:TextBox ID="txtOxydrops" runat="server" onkeypress="return (event.charCode >= 48 && event.charCode <= 57 || event.charCode >= 46 && event.charCode <= 48 )"></asp:TextBox>
                            </div>                         
                        </div> 
                        <div class="row">
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Urine Protein
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                   <asp:DropDownList ID="ddlUrineProtein" runat="server">
                                         <asp:ListItem Text="Select" Value="Select"></asp:ListItem>
                                         <asp:ListItem Text="Absent" Value="Absent"></asp:ListItem>
                                         <asp:ListItem Text="1+" Value="1+"></asp:ListItem>
                                         <asp:ListItem Text="2+" Value="2+"></asp:ListItem>
                                         <asp:ListItem Text="3+" Value="3+"></asp:ListItem>                                        
                                   </asp:DropDownList>  
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Urine Volume
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-4">
                                 <asp:TextBox ID="txtUrineVol"  placeholder="____mls" runat="server"></asp:TextBox>
                            </div>
                            <div class="col-md-1">
                                <span class="auto-style7">mls</span>
                            </div>
                            <div class="col-md-3">
                                <label class="pull-left">
                                    Urine Ketones
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                  <asp:DropDownList ID="ddlUrineKetones" runat="server">
                                         <asp:ListItem Text="Select" Value="Select"></asp:ListItem>
                                         <asp:ListItem Text="Absent" Value="Absent"></asp:ListItem>
                                         <asp:ListItem Text="1+" Value="1+"></asp:ListItem>
                                         <asp:ListItem Text="2+" Value="2+"></asp:ListItem>
                                         <asp:ListItem Text="3+" Value="3+"></asp:ListItem>                                        
                                   </asp:DropDownList> 
                            </div>                          
                        </div>      
                        <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left">
                                    Drugs Given
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-16">
                                <asp:TextBox ID="txtDrugs" runat="server" TextMode="MultiLine" Height="70px"></asp:TextBox>
                            </div>                    
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <label class="pull-left">
                                    IV Fluids Given
                                </label>
                                <b class="pull-right">:</b>
                            </div>
                            <div class="col-md-16">
                                <asp:TextBox ID="txtFluids" runat="server" TextMode="MultiLine" Height="70px"></asp:TextBox>
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
                <asp:Button ID="btnUpdate" ClientIDMode="Static" runat="server" Text="Update" Visible="false" CssClass="ItDoseButton" TabIndex="69" OnClientClick="return note();" OnClick="btnUpdate_Click" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="ItDoseButton" TabIndex="69" Visible="false" OnClick="btnCancel_Click" />                
            </div>

            <div class="POuter_Box_Inventory" runat="server" id="CervixDescenEntryDiv">
                <div class="Purchaseheader">
                    <b>Cervix And Descent Chart </b>
                </div>
                <div class="POuter_Box_Inventory">
                  <div style="display:none">
                        <table style="width: 20%">
                            <tr>
                                <td style="text-align:right" class="auto-style1" >
                                    Date :&nbsp;
                                </td>
                                <td style="width:145px; text-align:left">
                                    <asp:TextBox ID="txtDate1" onchange="bindData()" runat="server" ClientIDMode="Static"></asp:TextBox>
                                                <cc1:CalendarExtender ID="caldate" runat="server" TargetControlID="txtDate1" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                                </td>                 
                            </tr>
                        </table>           
                 </div>                 
                  <div id="ItemOutput" style="max-height: 600px; overflow-x: auto;"></div>
               </div> 
                              
              <div style="text-align: center;">
                        <input type="button" value="Save" id="btnCervixDescentsave" class="ItDoseButton" onclick="saveIntake()" />
              </div>                
         </div>             
   </div>

            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="height: 19px;">
                    Results
                </div>
                <table id="tbNursingprogress">
                    <tr>
                        <td>
                            <div style="text-align: center; ">
                                <asp:GridView ID="grdNursing" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" Width="100%" OnRowDataBound="grdNursing_RowDataBound" OnRowCommand="grdNursing_RowCommand" OnPageIndexChanging="OnPageIndexChanging" AllowPaging="true" PagerSettings-PageButtonCount="5">

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
                                         <asp:TemplateField HeaderText="DDate">
                                            <ItemTemplate>
                                                <asp:Label ID="lblDilationDate" runat="server" Text='<%#Eval("DilationDate") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="DTime">
                                            <ItemTemplate>
                                                <asp:Label ID="lblDilationTime" runat="server" Text='<%#Eval("DilationTime") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                         <asp:TemplateField HeaderText="Gravi.">
                                            <ItemTemplate>
                                                <asp:Label ID="lblGravida" runat="server" Text='<%#Eval("Gravida") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Para">
                                            <ItemTemplate>
                                                <asp:Label ID="lblPara" runat="server" Text='<%#Eval("Para") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>  
                                         <asp:TemplateField HeaderText="FHR">
                                            <ItemTemplate>
                                                <asp:Label ID="lblFHR" runat="server" Text='<%#Eval("FHR") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField> 
                                        <asp:TemplateField HeaderText="Temp">
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
                                        <asp:TemplateField HeaderText="AMF">
                                            <ItemTemplate>
                                                <asp:Label ID="lblAMF" runat="server" Text='<%#Eval("AMF") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Mould.">
                                            <ItemTemplate>
                                                <asp:Label ID="lblMoulding" runat="server" Text='<%#Eval("Moulding") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Cervix">
                                            <ItemTemplate>
                                                <asp:Label ID="lblCervix" runat="server" Text='<%#Eval("Cervix") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Descent">
                                            <ItemTemplate>
                                                <asp:Label ID="lblDescent" runat="server" Text='<%#Eval("Descent") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Contra.">
                                            <ItemTemplate>
                                                <asp:Label ID="lblContractions" runat="server" Text='<%#Eval("Contractions") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Lasting">
                                            <ItemTemplate>
                                                <asp:Label ID="lblLasting" runat="server" Text='<%#Eval("Lasting") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="OxyinML">
                                            <ItemTemplate>
                                                <asp:Label ID="lblOxyinML" runat="server" Text='<%#Eval("OxyinML") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                          <asp:TemplateField HeaderText="Oxydrops">
                                            <ItemTemplate>
                                                <asp:Label ID="lblOxydrops" runat="server" Text='<%#Eval("Oxydrops") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="UProt.">
                                            <ItemTemplate>
                                                <asp:Label ID="lblUrineProtein" runat="server" Text='<%#Eval("UrineProtein") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="UVol">
                                            <ItemTemplate>
                                                <asp:Label ID="lblUrineVol" runat="server" Text='<%#Eval("UrineVol") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField> 
                                         <asp:TemplateField HeaderText="UKeto.">
                                            <ItemTemplate>
                                                <asp:Label ID="lblUrineKetones" runat="server" Text='<%#Eval("UrineKetones") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>                   
                                        <asp:TemplateField HeaderText="Drugs">
                                            <ItemTemplate>
                                                <asp:Label ID="lblDrugs" runat="server" Text='<%#Eval("Drugs") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                         <asp:TemplateField HeaderText="Fluids">
                                            <ItemTemplate>
                                                <asp:Label ID="lblFluids" runat="server" Text='<%#Eval("Fluids") %>'></asp:Label>
                                            </ItemTemplate>
                                            <ItemStyle CssClass="GridViewItemStyle" />
                                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Induction"  Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblInduction" runat="server" Text='<%#Eval("Induction") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Duration "  Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblDuration" runat="server" Text='<%#Eval("Duration") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="NoOfVE"   Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblNoOfVE" runat="server" Text='<%#Eval("NoOfVE") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="ANormalPower1"  Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblHours" runat="server" Text='<%#Eval("Hours") %>'></asp:Label>
                                <asp:Label ID="lblMins" runat="server" Text='<%#Eval("Mins") %>'></asp:Label>
                                <asp:Label ID="lblMode" runat="server" Text='<%#Eval("Mode1") %>'></asp:Label>
                                <asp:Label ID="lblDuration1" runat="server" Text='<%#Eval("Duration1") %>'></asp:Label>
                                <asp:Label ID="lblmins1" runat="server" Text='<%#Eval("mins1") %>'></asp:Label>
                                <asp:Label ID="lblAMTSL" runat="server" Text='<%#Eval("AMTSL") %>'></asp:Label>
                                <asp:Label ID="lblUterotonic" runat="server" Text='<%#Eval("Uterotonic") %>'></asp:Label>
                                <asp:Label ID="lblDuration2" runat="server" Text='<%#Eval("Duration2") %>'></asp:Label>
                                <asp:Label ID="lblAlive" runat="server" Text='<%#Eval("Alive") %>'></asp:Label>
                                <asp:Label ID="lblM" runat="server" Text='<%#Eval("M") %>'></asp:Label>
                                <asp:Label ID="lblApgarScore1Min" runat="server" Text='<%#Eval("ApgarScore1Min") %>'></asp:Label>
                                <asp:Label ID="lblApgarScore5Min" runat="server" Text='<%#Eval("ApgarScore5Min") %>'></asp:Label>
                                <asp:Label ID="lblApgarScore10Min" runat="server" Text='<%#Eval("ApgarScore10Min") %>'></asp:Label>
                                <asp:Label ID="lblResusation" runat="server" Text='<%#Eval("Resusation") %>'></asp:Label>
                                <asp:Label ID="lblDuration3" runat="server" Text='<%#Eval("Duration3") %>'></asp:Label>
                                <asp:Label ID="lblMins3" runat="server" Text='<%#Eval("Mins3") %>'></asp:Label>
                                <asp:Label ID="lblPlacenta" runat="server" Text='<%#Eval("Placenta") %>'></asp:Label>
                                <asp:Label ID="lblMembranes" runat="server" Text='<%#Eval("Membranes") %>'></asp:Label>
                                <asp:Label ID="lblCord" runat="server" Text='<%#Eval("Cord") %>'></asp:Label>
                                <asp:Label ID="lblPlacentaWt" runat="server" Text='<%#Eval("PlacentaWt") %>'></asp:Label>
                                <asp:Label ID="lblEstBloodLoss" runat="server" Text='<%#Eval("EstBloodLoss") %>'></asp:Label>
                                <asp:Label ID="lblDevinial" runat="server" Text='<%#Eval("Devinial") %>'></asp:Label>
                                <asp:Label ID="lblBP1" runat="server" Text='<%#Eval("BP1") %>'></asp:Label>
                                <asp:Label ID="lblPulse1" runat="server" Text='<%#Eval("Pulse1") %>'></asp:Label>
                                <asp:Label ID="lblTemp1" runat="server" Text='<%#Eval("Temp1") %>'></asp:Label>
                                <asp:Label ID="lblResp1" runat="server" Text='<%#Eval("Resp1") %>'></asp:Label>
                                <asp:Label ID="lblLength" runat="server" Text='<%#Eval("Length1") %>'></asp:Label>
                                <asp:Label ID="lblWeight" runat="server" Text='<%#Eval("Weight") %>'></asp:Label>
                                <asp:Label ID="lblHC" runat="server" Text='<%#Eval("HC") %>'></asp:Label>
                                <asp:Label ID="lblDrugsGiven" runat="server" Text='<%#Eval("DrugsGiven") %>'></asp:Label>
                                <asp:Label ID="lblDeliveryBy" runat="server" Text='<%#Eval("DeliveryBy1") %>'></asp:Label>
                                </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="70" />
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
    </form>
</body>
</html>
 <script type="text/javascript">
     function Intake() {
         var dataIntake = new Array();
         var ObjIntake = new Object();
         jQuery("#tb_grdIntake tr").each(function () {
             var id = jQuery(this).attr("id");
             var $rowid = jQuery(this).closest("tr");
             if ((id != "Header") || (id != "undefined") || (id != "")) {
                 if ($rowid.find("#chkSelect").is(':checked') == true) {
                     ObjIntake.Date = $("#txtDate1").val();
                     ObjIntake.Time = $rowid.find("#tdTime_Label").text();
                                          
                     //  ObjIntake.Cervix = $rowid.find("input[id*=txtCervix]").val();
                     ObjIntake.Cervix = $rowid.find("#txtCervix option:selected").val();

                     //  ObjIntake.Descent = $rowid.find("input[id*=txtDescent]").val();                    
                     ObjIntake.Descent = $rowid.find("#txtDescent option:selected").val();
                     
                     if (ObjIntake.Cervix == "Select" || ObjIntake.Descent == "Select") {                        
                         return ;
                     }

                     ObjIntake.Alert = $rowid.find("input[id*=txtAlert]").val();
                     ObjIntake.Action = $rowid.find("input[id*=txtAction]").val();
                     ObjIntake.CreatedBy = $rowid.find("#tdCreatedBy").html();
                     ObjIntake.ID = $rowid.find("#tdID").html();
                     dataIntake.push(ObjIntake);
                     ObjIntake = new Object();
                 }
             }

         });
         return dataIntake;
     }

     function saveIntake() {
         var resultIntake = Intake();
         var TID = '<%=Request.QueryString["TransactionID"]%>';
                var PID = '<%=Request.QueryString["PatientId"]%>';
                if (resultIntake != "") {
                    $.ajax({
                        type: "POST",
                        data: JSON.stringify({ Intake: resultIntake, PID: PID, TID: TID }),
                        url: "Partograph.aspx/saveData",
                        dataType: "json",
                        contentType: "application/json;charset=UTF-8",
                        timeout: 120000,
                        async: false,
                        success: function (result) {
                            IntakeOutPut = (result.d);
                            if (IntakeOutPut == "1") {
                                // $("#lblMsg").text('Record Saved Successfully');
                                modelAlert("Record Saved Successfully", function () {
                                    getData();
                                    return;
                                });
                            }
                            else {
                                //  $("#lblMsg").text('Error occurred, Please contact administrator');
                                modelAlert("Error occurred, Please contact administrator", function () {
                                    getData();
                                    return;
                                });
                            }
                            $('#btnCervixDescentsave').removeProp('disabled');
                        },
                        error: function (xhr, status) {
                            window.status = status + "\r\n" + xhr.responseText;
                            // $("#lblMsg").text('Error occurred, Please contact administrator');
                            modelAlert("Error occurred, Please contact administrator", function () {
                                $('#btnCervixDescentsave').removeProp('disabled');
                                return;
                            });
                           
                        }

                    });
                }               
                else
                    //  $("#lblMsg").text('Please Select At Least One CheckBox');
                    modelAlert("1. Please Select At Least One CheckBox <br/>  2. Please Pickup a value in place of Select. ", function () {
                        return;
                    });
            }
        </script>
     <script type="text/javascript">
         $(function () {
             getData()
         });

         function getData() {
             var TransID = '<%=Request.QueryString["TransactionID"]%>';
                jQuery.ajax({
                    type: "POST",
                    url: "Partograph.aspx/bindData",
                    data: '{TransID:"' + TransID + '",Date:"' + $("#txtDate1").val() + '"}',
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    success: function (response) {
                        Newitem = jQuery.parseJSON(response.d);
                        if (Newitem != null) {
                            var output = jQuery('#tb_Item').parseTemplate(Newitem);
                            jQuery('#ItemOutput').html(output);
                            jQuery('#ItemOutput').show();
                            bindcervixvalue();
                            //  $("#lblMsg").text(' ');
                        }

                        else {
                            jQuery('#ItemOutput').hide();
                        }
                    },
                    error: function (xhr, status) {

                    }
                });
            }
        </script>
<script type="text/javascript">
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
    function bindcervixvalue() {
        $('[id$=txtCervix]').append($("<option></option>").val("Select").html("Select"));
        for (var i = 0; i < 11; i++) {
           
            $('[id$=txtCervix]').append($("<option></option>").val(i).html(i));
        }

        $('.trData').each(function () {
            $(this).find('[id$=txtCervix]').val($(this).find('#tdCervixValue').html());
        });
        $('.trData').each(function () {
            $(this).find('[id$=txtDescent]').val($(this).find('#tdDescentValue').html());
        });
    }
</script>
  <script id="tb_Item" type="text/html">
	<table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdIntake"
	style="width:920px;border-collapse:collapse;">      
		<tr id="Header">			
			<th class="GridViewHeaderStyle" scope="col" style="width:120px;">Time</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px;">Cervix</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">Descent</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:90px; display:none">Alert</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:90px; display:none">Action</th>			
            <th class="GridViewHeaderStyle" scope="col" style="width:90px;">Entered By</th>	
            <th class="GridViewHeaderStyle" scope="col" style="width:90px; display:none">ID</th>		
            <th class="GridViewHeaderStyle" scope="col" style="width:80px; "></th>		           
		</tr>
		<#       
		var dataLength=Newitem.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;   
		for(var j=0;j<dataLength;j++)
		{       
		objRow = Newitem[j];
		#>
			<tr class="trData" id="<#=j+1#>">
                                                                     
					<td class="GridViewLabItemStyle" id="tdTime_Label"  style="text-align:left" ><#=objRow.Time_Label#></td>
					<td class="GridViewLabItemStyle" id="tdCervix"  style="width:90px;text-align:center" >                       
                         <%--<input type="text" id="txtCervix" maxlength="10"    style="width:70px" title="<#=objRow.Cervix#>" value="<#=objRow.Cervix#>" onkeypress="return checkForSecondDecimal(this,event)" 
                            <#if(objRow.Name !=""){#> 
                       disabled="disabled"   <#}
                              else{#> 
                         <#}
                              #>                           
                             > </input>  --%>    
                         <select id="txtCervix" >
                                                                
                        </select>      
                                  
					</td>
                <td class="GridViewLabItemStyle" id="tdCervixValue"  style="width:90px;text-align:center;display:none" ><#=objRow.Cervix#></td>                
                    <td class="GridViewLabItemStyle" id="tdDescent" style="width:80px;text-align:center; ">
                       <%-- <input type="text" id="txtDescent" maxlength="4" onpaste="return false" style="width:60px" value="<#=objRow.Descent#>" onkeypress="return checkForSecondDecimal(this,event)" 
                            <#if(objRow.Name !=""){#> 
                        disabled="disabled"  <#}  #>                           
                             > </input>--%>
                       <select id="txtDescent" >
                                         <option value="Select">Select</option>
                                         <option value="0">0</option>
                                         <option value="1">1</option>
                                         <option value="2">2</option>
                                         <option value="3">3</option>
                                         <option value="4">4</option>
                                         <option value="5">5</option>                                        
                           
                        </select>                         
                    </td>
                    <td class="GridViewLabItemStyle" id="tdDescentValue"  style="width:90px;text-align:center;display:none" ><#=objRow.Descent#></td>

					<td class="GridViewLabItemStyle" id="tdAlert"  style="width:90px; display:none; text-align:center" >
                          <input type="text" id="txtAlert" maxlength="10" style="width:70px;" value="<#=objRow.Alert#>"
                             <#if(objRow.Name !=""){#> 
                        disabled="disabled" <#} #>                            
                             > </input>
                     </td>

                     <td class="GridViewLabItemStyle" id="tdAction"  style="width:90px; display:none; text-align:center" >
                          <input type="text" id="txtAction" maxlength="10" style="width:70px;" value="<#=objRow.Action#>"
                             <#if(objRow.Name !=""){#> 
                        disabled="disabled" <#} #>                            
                             > </input>
                     </td>

                     <td class="GridViewLabItemStyle" id="tdCreatedBy" style="width:100px;text-align:left"><#=objRow.Name#></td>

                     <td class="GridViewLabItemStyle" id="tdID" style="width:100px; display:none; text-align:left"><#=objRow.ID#></td>
					
			         <td class="GridViewLabItemStyle" id="tdSelect"  style="width:80px;text-align:left" ><input type="checkbox" id="chkSelect" 
                          <#if(objRow.Name !=""){#> 
                                disabled="disabled" <#} #>                 
                      /></td>  
            </tr> 
		<#}        
		#>      
	 </table>
	</script>
