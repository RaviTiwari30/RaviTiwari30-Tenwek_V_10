<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PatientCode.aspx.cs" Inherits="Design_IPD_PatientCode" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
      <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>

    <script type="text/javascript">
        $(document).ready(function () {

            $BindCodemaster();
            $BindPatientCode();
        });
        $BindCodemaster = function () {
            serverCall('PatientCode.aspx/bindCodemasterlist', {}, function (response) {
                var $ddlPatientCode = $('#ddlPatientCode');
                $ddlPatientCode.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'CodeType', isSearchAble: true });
                
            });
        }

        $BindPatientCode = function () {
           var TID= '<%=Request.QueryString["TID"]%>'
            serverCall('PatientCode.aspx/BindPCode', { TID: TID }, function (response) {
                   var responseData = JSON.parse(response);
                   if (responseData.status == true) {
                       $('#ddlPatientCode').chosen('destroy').val(responseData.response);
                       $('#ddlPatientCode').chosen();
                   }

               });
           }


        $PatientCodeUpdate = function ()
        {
           if ($('#ddlPatientCode').val() == "0") {
               modelAlert('Please Select Any Type Of Code');
               return false;
           }
           var data = {
               Pcode: $('#ddlPatientCode').val(),
               TID: '<%=Request.QueryString["TID"]%>',
               PID: '<%=Request.QueryString["PID"]%>',
           }
           serverCall('PatientCode.aspx/SavePatientCode', data, function (response) {

               var responseData = JSON.parse(response);
               if (responseData.Status == true) {
                   modelAlert(responseData.response);
               }

               else {
                   modelAlert(responseData.response);
               }

           });
        }
        </script>
    <form id="form1" runat="server">
    
     <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div class="content" style="text-align: center;">
                <b>Patient Code</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
            </div>
            <div class="Purchaseheader">
                Patient Code Update
                </div>
                <div class="row">
                    <div class="col-md-3">
                    <label class="pull-left">Code Name</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                     <select id="ddlPatientCode" title="Patient Code" class="requiredField"></select>
                    </div>
                     <div class="col-md-3">
                        <input type="button" id="btnPatientCode" value="Save" onclick="$PatientCodeUpdate()" />
                    </div>
                
            </div>
        </div>
         </div>
    
    </form>
</body>
</html>
