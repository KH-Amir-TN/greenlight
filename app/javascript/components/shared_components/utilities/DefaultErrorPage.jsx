import { ArrowCircleLeftIcon, ExclamationCircleIcon } from '@heroicons/react/outline';
import React, { useState } from 'react';
import {
  Button, Card, Col, Row, Stack,
} from 'react-bootstrap';
import { useTranslation } from 'react-i18next';
import { useNavigate } from 'react-router-dom';
import PropTypes from 'prop-types';

export default function DefaultErrorPage({ error, errorInfo }) {
  const [open, setOpen] = useState(false);
  const navigate = useNavigate();
  const { t } = useTranslation();

  const issue = {
    lables: 'v3-alpha,bug',
    template: 'greenlight-issue.md',
    title: `Error Message: "${error}"`,
  };
  const issueUrl = `https://github.com/bigbluebutton/greenlight/issues/new?labels=${issue.labels}&template=${issue.template}&title=${issue.title}`;

  return (
    <Row className="vertical-center text-center">
      <Row>
        <h1>{t('global_error_page.title')}</h1>
      </Row>
      <Row>
        <Col md={8} className="mx-auto">
          <Card className="p-5 border-0 shadow-sm">
            {(!open && (
              <>
                <ExclamationCircleIcon className="hi-xl mx-auto" />
                <pre className="text-muted">
                  {t('global_error_page.message')}
                  <a target="_blank" rel="noreferrer" href={issueUrl}>{t('report')}</a>
                </pre>
              </>
            )) || (
              <div className="text-justify">
                <p>{error && error.toString()}</p>
                <br />
                <h4>{t('global_error_page.trace.title')}</h4>
                <pre>{errorInfo.componentStack}</pre>
              </div>
            )}

            <Stack className="mx-auto" gap={1} direction="horizontal">
              <Button variant="neutral" onClick={() => setOpen(!open)}>
                {(!open && t('global_error_page.trace.show_btn_lbl')) || t('global_error_page.trace.hide_btn_lbl')}
              </Button>
              <Button variant="primary" onClick={() => navigate(-1)}>
                <ArrowCircleLeftIcon className="hi-s" /> {t('back')}
              </Button>
            </Stack>
          </Card>
        </Col>
      </Row>
    </Row>
  );
}

DefaultErrorPage.propTypes = {
  error: PropTypes.shape({}).isRequired,
  errorInfo: PropTypes.shape({ componentStack: PropTypes.string }).isRequired,
};
