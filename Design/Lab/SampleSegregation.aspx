<%@ Page Language="C#" ValidateRequest="false" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master"
    CodeFile="SampleSegregation.aspx.cs" Inherits="Design_SampleCollection_SampleSegregation" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">

    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script type="text/javascript">
        $(document).ready(function () {
            $('#FrmDate').change(function () {
                ChkDate();
            });
            $('#ToDate').change(function () {
                ChkDate();
            });
            show();
            $('#<%=rdbLabType.ClientID%>').change(function () {
                $('#grdhide').hide();
            });
            $('#<%=rbtSample.ClientID%>').change(function () {
                $('#grdhide').hide();
            });
            $('#<%=rbtSegregate.ClientID%>').change(function () {
                $('#grdhide').hide();
            });
        });


        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#FrmDate').val() + '",DateTo:"' + $('#ToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>').attr('disabled', 'disabled');
                        $('#grdhide').hide();
                        $('#<%=grdLabSearch.ClientID %>').hide();
                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeAttr('disabled');
                    }
                }
            });
        }
        function show() {
            if ($("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val() == 'OPD') {
                //  $("#<%=txtCRNo.ClientID %>").val('').prop('readOnly', 'true');
                $("#<%=txtCRNo.ClientID %>").val('').hide();
                $("#<%=lblIPDNo.ClientID %>").hide();
                $("#<%=lblcln.ClientID %>").hide();

            }
            if ($("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val() == 'IPD') {
                //$("#<%=txtCRNo.ClientID %>").removeAttr('readOnly');
                $("#<%=txtCRNo.ClientID %>").val('').show();
                $("#<%=lblIPDNo.ClientID %>").show();
                $("#<%=lblcln.ClientID %>").show();
            }
        }
        $("#<%=rdbLabType.ClientID %> input:radio").change(function () {
            if ($("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val() == 'OPD') {
                $("#<%=grdLabSearch.ClientID %>").hide();
            }
            if ($("#<%=rdbLabType.ClientID %> input[type=radio]:checked").val() == 'IPD') {
                $("#<%=grdLabSearch.ClientID %>").hide();
            }

        });

    </script>
    <script type="text/javascript">
        function disableButton(btn) {
            document.getElementById('<%=btnSearch.ClientID%>').disabled = true;
            document.getElementById('<%=btnSearch.ClientID%>').value = 'Searching...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSearch', '');
        }
        function disableSave(btn) {
            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Saving...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
        }
</script>  
      <script type="text/javascript">
          $(function () {
              $("[id*=chkHeader]").live("click", function () {
                  var chkHeader = $(this);
                  var grid = $(this).closest("table");
                  $("input[type=checkbox]", grid).each(function () {
                      if (chkHeader.is(":checked")) {
                          $(this).attr("checked", "checked");
                          $("td", $(this).closest("tr")).addClass("selected");
                      } else {
                          $(this).removeAttr("checked");
                          $("td", $(this).closest("tr")).removeClass("selected");
                      }
                  });
              });
              $("[id*=chkSampleSegregate]").live("click", function () {
                  var grid = $(this).closest("table");
                  var chkHeader = $("[id*=chkHeader]", grid);
                  if (!$(this).is(":checked")) {
                      $("td", $(this).closest("tr")).removeClass("selected");
                      chkHeader.removeAttr("checked");
                  } else {
                      $("td", $(this).closest("tr")).addClass("selected");
                      if ($("[id*=chkSampleSegregate]", grid).length == $("[id*=chkSampleSegregate]:checked", grid).length) {
                          chkHeader.attr("checked", "checked");
                      }
                  }
              });
          });
    </script>
    <div id="Pbody_box_inventory">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Sample Segregation</b><br />
            <asp:Label ID="lblMsg" ClientIDMode="Static" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdbLabType" runat="server" RepeatDirection="Horizontal"
                                Font-Bold="True" onclick="show();">
                                <asp:ListItem Text="OPD" Value="OPD" Selected="True"></asp:ListItem>
                                <asp:ListItem Text="IPD" Value="IPD"></asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMRNo" runat="server" MaxLength="30" ToolTip="Enter UHID"
                                TabIndex="1" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:Label ID="lblIPDNo" Text="IPD No." runat="server" Style="display: none"></asp:Label>
                            </label>
                            <b id="lblcln" runat="server" class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCRNo" runat="server" MaxLength="10" ToolTip="Enter IPD No."
                                TabIndex="2" Style="display: none" />
                            <cc1:FilteredTextBoxExtender ID="ftbtxtCRNo" TargetControlID="txtCRNo" FilterType="Numbers" runat="server"></cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Lab No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtLabNo" runat="server" MaxLength="10" ToolTip="Enter Lab No."
                                TabIndex="3" />
                            <cc1:FilteredTextBoxExtender ID="ftbtxtLabNo" TargetControlID="txtLabNo" FilterType="Numbers"
                                runat="server">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPName" runat="server" MaxLength="30" ToolTip="Enter Name"
                                TabIndex="4" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left" >
                               Segregation
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rbtSample" ClientIDMode="Static" Style="display: none;" runat="server" RepeatDirection="Horizontal" ToolTip="Select Sample Collected"
                                TabIndex="5">
                                <asp:ListItem Value="N">No</asp:ListItem>
                                <asp:ListItem Selected="True" Value="Y">Yes</asp:ListItem>
                                <asp:ListItem Value="R">Rejected</asp:ListItem>
                                <asp:ListItem Value="T" style="display: none">Transfer</asp:ListItem>
                                <asp:ListItem Value="O" style="display: none">Outsource</asp:ListItem>
                            </asp:RadioButtonList>
                            <asp:RadioButtonList ID="rbtSegregate" ClientIDMode="Static" runat="server" RepeatDirection="Horizontal" ToolTip="Select Sample Segregation"
                                TabIndex="5">
                                <asp:ListItem Selected="True" Value="0">No</asp:ListItem>
                                <asp:ListItem Value="1">Yes</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Patient Test Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlUrgent" runat="server" TabIndex="6" ToolTip="Select Patient Test Type">
                                <asp:ListItem Selected="True" Value="2">All</asp:ListItem>
                                <asp:ListItem Value="1">Urgent</asp:ListItem>
                                <asp:ListItem Value="0">Normal</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Department
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddldepartment" runat="server"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Doctor
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDoctor" runat="server"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="FrmDate" runat="server" ClientIDMode="Static" TabIndex="7" onchange="ChkDate()"
                                ToolTip="Select From Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="calEntryDate1" runat="server" Format="dd-MMM-yyyy" TargetControlID="FrmDate">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="ToDate" runat="server" ClientIDMode="Static" TabIndex="8" onchange="ChkDate()"
                                ToolTip="Select To Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" Format="dd-MMM-yyyy"
                                TargetControlID="ToDate">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>

                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                    <div class="row"></div>
                    <div class="row">
                        <div class="col-md-11"></div>
                        <div class="col-md-2">
                            <asp:Button ID="btnSearch" runat="server" ClientIDMode="Static" OnClientClick="return disableButton(this)" CssClass="ItDoseButton"
                                Text="Search" OnClick="btnSearch_Click" />
                        </div>
                        <div class="col-md-11"></div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3"></div>
                        <div class="col-md-4">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; border: black thin solid; float: left; background-color: pink;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Urgent</b>
                        </div>
                        <div class="col-md-4">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; border: black thin solid; background-color: White;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Normal</b>
                        </div>
                        <div class="col-md-4">
                            <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; border: black thin solid; background-color: #00FFFF;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Outsource</b>
                        </div>
                        <div class="col-md-6">
                             <button type="button" style="width: 25px; height: 25px; margin-left: 5px; float: left; border: black thin solid; background-color:lightgreen;" class="circle"></button>
                            <b style="margin-top: 5px; margin-left: 5px; float: left">Segregate</b>
                        </div>
                        <div class="col-md-3"></div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div id="grdhide">
            <asp:Panel ID="pnlHide" runat="server" Visible="false">
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader" id="header">
                        Search Result
                    </div>

                    <asp:GridView ID="grdLabSearch" Width="100%" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                        OnRowDataBound="grdLabSearch_RowDataBound">
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemStyle CssClass="GridViewLabItemStyle" Width="20px" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="UHID">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="70px" />
                                <ItemTemplate>

                                    <asp:Label ID="lblMRNo" runat="server" Text='<%#Eval("PatientID") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="IPD No.">
                                <ItemTemplate>
                                    <%# Util.GetString(Eval("TransactionID")).Replace("LLSHHI","").Replace("LSHHI","").Replace("LISHHI","").Replace("ISHHI","")%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Room">
                                <ItemTemplate>
                                    <%# Util.GetString(Eval("room"))%>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Lab&nbsp;No.">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Font-Bold="True" Width="60px" />
                                <ItemTemplate>
                                    <asp:Label ID="lblLedTnx" runat="server" Text='<%# Util.GetString(Eval("LedgerTransactionNo")).Replace("LISHHI","").Replace("LOSHHI","") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Patient Name">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="145px" />
                                <ItemTemplate>
                                    <asp:Label ID="lbl_PName" runat="server" Text='<%#Eval("PName") %>'></asp:Label>

                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Age">
                                <ItemStyle CssClass="GridViewLabItemStyle" Width="60px" HorizontalAlign="Left" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                <ItemTemplate>
                                    <asp:Label ID="lbl_Age" runat="server" Text='<%#Eval("Age") %>'></asp:Label>
                                    <asp:Label ID="lblGender" runat="server" Visible="false" Text='<%#Eval("gender") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Department">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                <ItemTemplate>
                                    <%#Eval("ObservationName")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Investigation">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                                <ItemTemplate>
                                    <%#Eval("Name") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Date">
                                <ItemStyle CssClass="GridViewLabItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="115px" />
                                <ItemTemplate>
                                    <%#Eval("InDate") + " " + Eval("Time")%>
                                    <asp:Label ID="lblResult" runat="server" Text=' <%#Eval("IsResult") %>' Visible="false"></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    Segregation Department
                                </HeaderTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:Label ID="lblDepartment" Visible="false" runat="server" Text='<%# Eval("SegregateDeptLedgerNo") %>'></asp:Label>
                                    <asp:DropDownList ID="ddlDepartment" runat="server" Width="200px"></asp:DropDownList>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <HeaderTemplate>
                                    <asp:Label ID="lblHeader" runat="server" Text="All"></asp:Label>
                                    <asp:CheckBox ID="chkHeader" runat="server" Checked="true" CssClass="clChkAll" />
                                </HeaderTemplate>
                                <ItemStyle CssClass="GridViewLabItemStyle" HorizontalAlign="Center" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkSampleSegregate" runat="server" Checked="true" CssClass="clChk" />
                                    
                                     <asp:Label ID="lblisSegregate" runat="server" Text='<%#Eval("isSegregate") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblIs_Urgent" runat="server" Text='<%#Eval("IsUrgent") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblIs_Outsource" runat="server" Text='<%#Eval("IsOutsource") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblOutSourceID" runat="server" Text='<%#Eval("OutSourceID") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblOutSourceDone" runat="server" Text='<%#Eval("OutSourceDone") %>' Visible="false"></asp:Label>
                                    
                                    <asp:Label ID="lblTransactionID" runat="server" Text=' <%#Eval("TransactionID") %>'
                                        Visible="false"></asp:Label>
                                    <asp:Label ID="lblInvestigation_Id" runat="server" Text=' <%#Eval("Investigation_Id") %>'
                                        Visible="false"></asp:Label>
                                    <asp:Label ID="lblObservationType_Id" runat="server" Text=' <%#Eval("ObservationType_Id") %>'
                                        Visible="false"></asp:Label>
                                    <asp:Label ID="lblID" runat="server" Text=' <%#Eval("ID") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblEntryType" runat="server" Text=' <%#Eval("EntryType") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblTestId" runat="server" Text=' <%#Eval("Test_Id") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblLedgerTnxID" runat="server" Text=' <%#Eval("LedgerTnxID") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblLedTnx1" runat="server" Text='<%# Eval("LedgerTransactionNo1") %>' Visible="false"></asp:Label>
                                    <asp:Label ID="lblisTransferReceive" runat="server" Text=' <%#Eval("isTransferReceive") %>' Style="display: none"></asp:Label>
                                    <asp:Label ID="lblsampleTransferCentreID" runat="server" Text=' <%#Eval("sampleTransferCentreID") %>' Style="display: none"></asp:Label>
                                    
                                    <%--<asp:Label ID="lblPendingAmt" runat="server" Text='<%#Eval("PendingAmount") %>' Visible="false"></asp:Label>--%>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>

                </div>
                <div class="POuter_Box_Inventory">
                    <div style="text-align: center">
                        <asp:Button ID="btnSave" runat="server" CssClass="ItDoseButton" OnClick="btnSave_Click"
                            Text="Sample Segregation" OnClientClick="return disableSave(this)" ClientIDMode="Static" />
                    </div>
                </div>
            </asp:Panel>
        </div>
    </div>

</asp:Content>
