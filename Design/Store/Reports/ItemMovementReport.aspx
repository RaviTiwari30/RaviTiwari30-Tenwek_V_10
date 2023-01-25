<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ItemMovementReport.aspx.cs" Inherits="Design_Store_ItemMovementReport" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/UCStoreReportSearchCriteria.ascx" TagName="UCReportSearchCriteria" TagPrefix="UC1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
      <script type="text/javascript">
          $(function () {
              showhidefilter(1, 1, 0, 1, 1, 1, 1, 1, 1, 0);
              //showhidefilter(center, department, supplier, category, subcategory, item, fromdate, todate,reportype);
          });
          function getsearchparameter() {
              if (Getmultiselectvalue($('#lstcenter')) == '')
                  return [{ erroMessage: 'Please Select Center', type: 'V' }];
              if (Getmultiselectvalue($('#lstdepartment')) == '')
                  return [{ erroMessage: 'Please Select Department', type: 'V' }];

              var searchparameter = new Array();
              searchparameter[0] = Getmultiselectvalue($('#lstcenter'));
              searchparameter[1] = Getmultiselectvalue($('#lstdepartment'));
              searchparameter[2] = Getmultiselectvalue($('#lstCategory'));
              searchparameter[3] = Getmultiselectvalue($('#lstsubgroup'));
              searchparameter[4] = Getmultiselectvalue($('#lstitems'));
              searchparameter[5] = $('#txtdatefrom').val();
              searchparameter[6] = $('#txtdateTo').val();
              searchparameter[7] =  $.trim($("#<%=rdomovingType.ClientID%> input[type=radio]:checked").val());//$('input[type=radio][name=rdomovingType]:checked').val();
              searchparameter[8] = $.trim($("#<%=rdomovingType.ClientID%> input[type=radio]:checked option:selected").text());
              searchparameter[9] = $('input[type=radio][name=format]:checked').val() == "PDF" ? "PDF" : "EXCEL";;
              return searchparameter;
          }
          var reportprint = function () {
              getreport('ItemMovementReport.aspx/Store_Get_ItemMovement');
          }
    </script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
                    EnableScriptGlobalization="true" EnableScriptLocalization="true">
                </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Item Movement Report</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <UC1:UCReportSearchCriteria ID="reportsearchcriteria" runat="server" />

            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Report Type</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-16">
                            <asp:RadioButtonList ID="rdomovingType" runat="server" RepeatColumns="5" RepeatDirection="Horizontal" ClientIDMode="Static">
                                <asp:ListItem Selected="True" Text="Non Moving Item" Value="N" />
                                <asp:ListItem Text="Slow Moving Item" Value="S" />
                                <asp:ListItem Text="Fast Moving Item" Value="F" />
                            </asp:RadioButtonList>
                        </div>
                    </div>
                </div>
            </div>


            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">From Time</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                               <asp:TextBox ID="txtTime" TabIndex="6" runat="server" ClientIDMode="Static" text ="00:00 AM"  ></asp:TextBox>
                               <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time" TargetControlID="txtTime" AcceptAMPM="True"></cc1:MaskedEditExtender>
                               <cc1:MaskedEditValidator ID="maskTimeStart" runat="server" ControlToValidate="txtTime" ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Please Enter Time" InvalidValueMessage="Invalid Time ON" ForeColor="Red" Display="None"></cc1:MaskedEditValidator>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">To Time</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtToTime" TabIndex="6" runat="server" text ="11:59 PM" ClientIDMode="Static"></asp:TextBox>
                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" Mask="99:99" runat="server" MaskType="Time" TargetControlID="txtToTime" AcceptAMPM="True"></cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlToValidate="txtToTime" ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Please Enter Time" InvalidValueMessage="Invalid Time ON" ForeColor="Red" Display="None"></cc1:MaskedEditValidator>
                        </div>


                    </div>
                </div>
            </div>

          
      
        </div>

              <div class="POuter_Box_Inventory" style="text-align: center;">
                <input type="button" id="btnsearch" onclick="reportprint()" value="Report" />
            </div>
        <script type="text/javascript">
            function getreport(serviceurl) {
                $.blockUI({ message: '<h3><img src="../../../Images/loadingAnim.gif" /><br/>Just a moment...</h3>' });
                var data = getsearchparameter();

              

                data[5] = data[5] + ' ' + $('#txtTime').val();
                data[6] = data[6] + ' ' + $('#txtToTime').val();


                if (data[0].type == "V") {
                    $.unblockUI();
                    modelAlert(data[0].erroMessage, function () { $(data[0].control).focus(); });
                    return false;
                }
                serverCall(serviceurl, { data: data }, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.status) {
                        $.unblockUI();
                        window.open(responseData.responseURL);
                    }
                    else {
                        $.unblockUI();
                        modelAlert(responseData.message);
                    }
                });
            }
        </script>
</asp:Content>
