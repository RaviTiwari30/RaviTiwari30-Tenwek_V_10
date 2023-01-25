<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="NewReport.aspx.cs" Inherits="Reports_NewReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            var TransactionNumber = '<%=Util.GetString(Request.QueryString["TransactionNumber"])%>';
            if (TransactionNumber != '' && TransactionNumber !='null') {
                getReport(TransactionNumber, function () { });
        }
           
        });
        var getReport = function (TransactionNumber, callback) {
            serverCall('NewReport.aspx/GetReport', { transactionNumber: TransactionNumber }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status)
                    window.open(responseData.responseURL);
                else
                    moddelAlert(responseData.response);
            });
        }
	</script>
</asp:Content>

